package my.api;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.ext.web.Router;

public final class App {

  private final Vertx vertx = Vertx.vertx();

  private App() {
  }

  public static void main(String... args) {
    final String host = System.getenv("BIND_HOST");
    final int port = Integer.parseInt(System.getenv("BIND_PORT"));

    new App().start(host, port);
  }

  private void start(String host, int port) {
    vertx.deployVerticle(new HttpVerticle(host, port));
  }

  private class HttpVerticle extends AbstractVerticle {

    private final String host;

    private final int port;

    public HttpVerticle(String host, int port) {
      this.host = host;
      this.port = port;
    }

    @Override
    public void start(Future<Void> future) {
      Router router = Router.router(vertx);

      router.get("/").handler(ctx -> {
        final String message = "Hello from my-api!";

        ctx.response().putHeader("Content-Length", String.valueOf(message.length()));
        ctx.response().write(message);
      });

      vertx.createHttpServer().requestHandler(router::accept).listen(this.port, this.host, res -> {
        if (res.succeeded())
          future.complete();
        else
          future.fail(res.cause());
      });
    }

  }

}
