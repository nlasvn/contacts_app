import contact_app/web.{type Context}
import contact_app/web/home_page
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page.home(req)
    _ -> wisp.not_found()
  }
}
