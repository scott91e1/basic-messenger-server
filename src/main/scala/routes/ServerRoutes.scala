package routes

import java.sql.Connection

import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.server.Route

import model._
import database.actions.ServerActions

import scala.concurrent.{ExecutionContext, Future}

case class ServerRoutes()(implicit connection: Connection, executionContext: ExecutionContext) extends Routes {
  def routes: Route =
    pathPrefix("servers") {
      concat(
        post {
          authenticateUser { id =>
            decodeRequest {
              entity(as[CreatableServer]) { server =>
                val result: Future[Result[Server]] = Future(ServerActions.createServer(server, id))
                onComplete(result)(complete(_))
              }
            }
          }
        },
        get {
          path("search" / Segment) { name =>
            val result: Future[List[ChildServer]] = Future(ServerActions.findServers(name))
            onComplete(result)(complete(_))
          }
        },
        get {
          path("id" / Segment) { id =>
            val result: Future[Result[Server]] = Future(ServerActions.getServerById(id.toInt))
            onComplete(result)(complete(_))
          }
        },
        get {
          path("address" / Segment) { address =>
            val result: Future[Result[Server]] = Future(ServerActions.getServerByAddress(address))
            onComplete(result)(complete(_))
          }
        },
        put {
          path(Segment) { id =>
            authenticateAdmin(id) { _ =>
              decodeRequest {
                entity(as[UpdatableServer]) { server =>
                  val result: Future[Result[NoRootElement]] =
                    Future(ServerActions.updateServer(id.toInt, server))
                  onComplete(result)(complete(_))
                }
              }
            }
          }
        },
        put {
          path(Segment / "users" / Segment) { (server, user) =>
            authenticateModerator(server) { _ =>
              val result: Future[Result[NoRootElement]] =
                Future(ServerActions.addServerUser(server.toInt, user.toInt))
              onComplete(result)(complete(_))
            }
          }
        },
        put {
          path(Segment / "users" / Segment / "roles" / Segment) { (server, member, role) =>
            authenticateAdmin(server) { _ =>
              val result: Future[Result[NoRootElement]] =
                Future(ServerActions.updateUserRole(server.toInt, member.toInt, Role.withName(role)))
              onComplete(result)(complete(_))
            }
          }
        },
        delete {
          path(Segment) { id =>
            authenticateAdmin(id) { _ =>
              val result: Future[Result[NoRootElement]] = Future(ServerActions.deleteServer(id.toInt))
              onComplete(result)(complete(_))
            }
          }
        },
        delete {
          path(Segment / "users" / Segment) { (server, user) =>
            authenticateModerator(server) { _ =>
              val result: Future[Result[NoRootElement]] =
                Future(ServerActions.removeServerUser(server.toInt, user.toInt))
              onComplete(result)(complete(_))
            }
          }
        },
      )
    }
  }

