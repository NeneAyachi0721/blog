const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  transpileDependencies: true,

  devServer: {
    proxy: {
      "/api": {
        target: "http://localhost:1235",
        changeOrigin: true,
        // pathRewrite: {
        //   '^/api': ''
        // }
      },
    },

    client: {
      overlay: {
        warnings: false,
        errors: true,
        runtimeErrors: (error) => {

          const ignoreErrors = [
            "ResizeObserver loop completed with undelivered notifications",
            "ResizeObserver loop limit exceeded",
          ];

          if (
            ignoreErrors.some(
              (msg) => error.message && error.message.startsWith(msg),
            )
          ) {
            return false;
          }

          return true;
        },
      },
    },
  },
});
