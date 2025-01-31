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
  //use <- wisp.require_method(req, Get)
  let contact_decoder = {
    use id <- decode.field(0, decode.int)
    use first <- decode.field(1, decode.string)
    use last <- decode.field(2, decode.string)
    use phone <- decode.field(3, decode.string)
    use email <- decode.field(4, decode.string)
    decode.success(Contact(id:, first:, last:, phone:, email:))
  }

  let query = wisp.get_query(req) |> list.key_find("q")

  let sql_all = "select * from contacts"

  let sql_select =
    "select * from contacts 
    where first like ? OR last like ?"

  let query_result = case query {
    Ok(value) ->
      sqlight.query(
        sql_select,
        on: ctx.db,
        with: [
          sqlight.text("%" <> value <> "%"),
          sqlight.text("%" <> value <> "%"),
        ],
        expecting: contact_decoder,
      )
    Error(_) ->
      sqlight.query(sql_all, on: ctx.db, with: [], expecting: contact_decoder)
  }

  let contacts_result = case query_result {
    Error(err) -> [html.text(err.message)]
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
    html.body([], [
      html.header([], [
        html.h1([], [element.text("Contacts")]),
        html.form(
          [
            attribute.action("/contacts"),
            attribute.method("get"),
            attribute.class("tool-bar"),
          ],
          [
            html.label([attribute.for("search")], [element.text("Search Term ")]),
            html.input([
              attribute.id("search"),
              attribute.type_("search"),
              attribute.name("q"),
              attribute.placeholder("Enter the search term"),
            ]),
            html.input([attribute.type_("submit"), attribute.value("Search")]),
          ],
        ),
        html.ul([], contacts_result),
      ]),
    ])
    |> element.to_document_string_builder

  wisp.ok() |> wisp.html_body(html)
}
