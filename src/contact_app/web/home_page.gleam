import gleam/http.{Get, Post}
import lustre/attribute
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

pub fn home(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let html =
    html.body([], [
      html.header([], [html.h1([], [element.text("Hello from Home")])]),
    ])
    |> element.to_document_string_builder

  wisp.ok() |> wisp.html_body(html)
}
