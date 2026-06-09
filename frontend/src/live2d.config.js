import { createWidget } from "l2d-widget";

export function initLive2D() {
  createWidget({
    model: {
      path: "/models/NOIR/noir.model3.json",
      position: "left",
      width: 280,
      height: 250,
      draggable: true,
      mobile: false,
      tips: {
        welcomeMessage: ["欢迎来到王可昕的个人博客", "Ciallo～(∠・ω< )⌒☆"],
        messages: [
          "What are you doing?",
          "Stop touching me!",
          "HENTAI!",
          "Don't bully me like that!",
        ],
        duration: 4000,
        interval: 6000,
      },
    },
  });
}
