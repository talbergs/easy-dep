import { Module } from "cerebral";
import * as actions from "../actions";

export default Module({
    state: {
        connected: false,
    },
  signals: {
    onmessage: actions.onmessage,
    onconnected: actions.onconnected,
    ondisconnected: actions.ondisconnected,
  }
});


