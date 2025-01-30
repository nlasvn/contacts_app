import contact_app/web.{type Context}
import gleam/dynamic/decode
import gleam/http.{Get, Post}
import gleam/int
import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html
import sqlight
import wisp.{type Request, type Response}

pub type Contact {
  Contact(id: Int, first: String, last: String, phone: String, email: String)
}

pub fn contacts(req: Request, ctx: Context) -> Response {
  use <- wisp.require_method(req, Get)
  let contact_decoder = {
    use id <- decode.field(0, decode.int)
    use first <- decode.field(1, decode.string)
    use last <- decode.field(2, decode.string)
    use phone <- decode.field(3, decode.string)
    use email <- decode.field(4, decode.string)
    decode.success(Contact(id:, first:, last:, phone:, email:))
  }

  let sql = "select * from contacts"

  let query_result =
    sqlight.query(sql, on: ctx.db, with: [], expecting: contact_decoder)

  let contacts_result = case query_result {
    Error(_) -> [html.text("Contact not found")]
    Ok(a) ->
      a
      |> list.map(fn(contact) {
        html.li([], [
          element.text(
            "ID is: "
            <> int.to_string(contact.id)
            <> " First name is: "
            <> contact.first
            <> " Lastname is: "
            <> contact.last
            <> " Phone number is: "
            <> contact.phone
            <> " Email is: "
            <> contact.email,
          ),
        ])
      })
  }

  let html =
    html.header([], [html.ul([], contacts_result)])
    |> element.to_document_string_builder

  wisp.ok() |> wisp.html_body(html)
}
