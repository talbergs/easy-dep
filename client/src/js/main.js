import React from "react";
import { render } from "react-dom";
import App from "./components/App";
import { Container } from "@cerebral/react";
import controller from "./controller";

render(
  <Container controller={controller}>
    <App />
  </Container>,
  document.getElementById("root")
);

const wsEndpoint = module.hot
    ? 'ws://' + window.location.hostname + ':3000'
    : 'ws://' + window.location.host

controller.getSignal("openws")({
    ws: wsEndpoint,
    onmessage: 'socket.onmessage',
    onopen: 'socket.onconnected',
    onclose: 'socket.ondisconnected',
    reconnect: true,
})

