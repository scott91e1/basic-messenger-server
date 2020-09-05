package converters

import model._

object ElementConverters {
  sealed trait ReadableObjectConverter[A, B] {
    def convert(value: A): B
  }

  implicit class ToReadable[A](value: A) {
    def toRootReadable[B <: RootElement](implicit converter: ReadableObjectConverter[A, B]): B =
      converter convert value
    def toChildReadable[C <: ChildElement](implicit converter: ReadableObjectConverter[A, C]): C =
      converter convert value
  }

  // ChildReadable converters

  implicit object ChildServerConverter extends ReadableObjectConverter[Server, ChildServer] {
    override def convert(server: Server): ChildServer = ChildServer(
      id = server.id,
      name = server.name,
      address = server.address
    )
  }

  implicit object ChildUserConverter extends ReadableObjectConverter[User, ChildUser] {
    override def convert(user: User): ChildUser = ChildUser(
      id = user.id,
      username = user.username,
      status = user.status
    )
  }

  implicit object ChildMessageConverter extends ReadableObjectConverter[Message, ChildMessage] {
    override def convert(message: Message): ChildMessage = ChildMessage(
      id = message.id,
      content = message.content,
      sender = message.sender.toChildReadable,
      createdAt = message.createdAt
    )
  }

  // RootReadable converters

  implicit object RootServerConverter extends ReadableObjectConverter[Server, RootServer] {
    override def convert(server: Server): RootServer = RootServer(
      id = server.id,
      name = server.name,
      address = server.address,
      users = server.users.map(
          user => (user._1.toChildReadable, user._2)
      ),
      messages = server.messages.map(
        _.toChildReadable
      )
    )
  }

  implicit object RootUserConverter extends ReadableObjectConverter[User, RootUser] {
    override def convert(user: User): RootUser = RootUser(
      id = user.id,
      username = user.username,
      servers = user.servers.map(
        server => (server._1.toChildReadable, server._2)
      ),
      status = user.status
    )
  }

  implicit object RootMessageConverter extends ReadableObjectConverter[Message, RootMessage] {
    override def convert(message: Message): RootMessage = RootMessage(
      id = message.id,
      content = message.content,
      server = message.server.toChildReadable,
      sender = message.sender.toChildReadable,
      createdAt = message.createdAt
    )
  }
}