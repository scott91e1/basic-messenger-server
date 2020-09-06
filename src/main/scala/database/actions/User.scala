package database.actions

import java.sql.{Connection, ResultSet}

import model._
import model.{Failure, Result, Success}
import database.queries.{User => UserQueries}

object User {
 private def checkUsernameExists(username: String)(implicit connection: Connection): Boolean = {
    val statement = connection.prepareStatement(
      UserQueries.checkUsernameExists,
      ResultSet.TYPE_SCROLL_INSENSITIVE,
      ResultSet.CONCUR_READ_ONLY
    )
    statement.setString(1, username)

    val resultSet = statement.executeQuery()
    resultSet.first()
    resultSet.getRow > 0
  }

  private def checkPasswordIsValid(password: String): Boolean =
    password.length > 7 &&
      password.matches(".*[0-9].*") &&
      password.matches(".*[a-z].*") &&
      password.matches(".*[A-Z].*")

  def createUser(user: CreatableUser)(implicit connection: Connection): Result[RootUser] = {
    val usernameExists = checkUsernameExists(user.username)
    val passwordIsValid = checkPasswordIsValid(user.password)

    if (usernameExists) Failure("A user with that username already exists.")
    else if (!passwordIsValid) Failure(
      "Your password must be at least 8 characters and contain " +
        "at least one lowercase letter, uppercase letter, and number."
    )
    else {
      val statement = connection.prepareStatement(
        UserQueries.createUser,
        ResultSet.TYPE_SCROLL_SENSITIVE,
        ResultSet.CONCUR_READ_ONLY
      )
      statement.setString(1, user.username)
      statement.setString(2, user.password)
      statement.setInt(3, user.passwordReset.question)
      statement.setString(4, user.passwordReset.answer)

      val resultSet = statement.executeQuery()
      resultSet.first()

      Success(
        result = Some(
          RootUser(
            id = resultSet.getInt(1),
            username = resultSet.getString(2),
            servers = List[ChildUserServerRole](),
            status = Status.withName(resultSet.getString(3))
          )
        ),
        message = Some("User successfully created.")
      )
    }
  }

  private def getUserServers(id: Int)(implicit connection: Connection): List[ChildUserServerRole] = {
    val statement = connection.prepareStatement(UserQueries.getUserServers)
    statement.setInt(1, id)
    val resultSet = statement.executeQuery()
    resultSet.last()

    val serverRoleList = List[ChildUserServerRole]()
    while(resultSet.next()) {
      serverRoleList.+:(
        ChildUserServerRole(
          server = ChildServer(
            id = resultSet.getInt(1),
            name = resultSet.getString(2),
            address = resultSet.getString(3)
          ),
          role = Role.withName(resultSet.getString(4))
        )
      )
    }
    serverRoleList
  }

  def getUser(id: Int)(implicit connection: Connection): Result[RootUser] = {
    val statement = connection.prepareStatement(UserQueries.getUser)
    statement.setInt(1, id)

    val resultSet = statement.executeQuery()
    resultSet.last()

    if (resultSet.getRow < 1) Failure("User not found.")
    else {
      val servers = getUserServers(id)
      Success(
        result = Some(
          RootUser(
            id = id,
            username = resultSet.getString(1),
            servers = servers,
            status = Status.withName(resultSet.getString(2))
          )
        ),
        message = None
      )
    }
  }

  // def updateUser(user: UpdatableUser)(implicit connection: Connection): model.results.UserResult = ???

  def updateUsername(id: Int, username: String)(implicit connection: Connection): Result[RootUser] = {
    val usernameExists = checkUsernameExists(username)
    if (usernameExists) Failure("A user with that username already exists.")
    else {
      val statement = connection.prepareStatement(UserQueries.updateUsername)
      statement.setString(1, username)
      statement.setInt(2, id)
      statement.executeUpdate()

      Success(
        result = None,
        message = Some("Your username has been updated.")
      )
    }
  }

  def updateStatus(id: Int, status: Status.Value)(implicit connection: Connection): Result[RootUser] = {
    val statement = connection.prepareStatement(UserQueries.updateUsername)
    statement.setString(1, status.toString)
    statement.setInt(2, id)
    statement.executeUpdate()

    Success(
      result = None,
      message = Some("Your status has been updated.")
    )
  }
}
