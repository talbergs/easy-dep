import { Module } from "cerebral"
import * as actions from "./actions"
import ws from './providers/ws';
import socket from './modules/socket'
import sysPanel from './modules/sysPanel'
import stdoutPanel from './modules/stdoutPanel'
import stderrPanel from './modules/stderrPanel'
import conf from './modules/conf'
import layout from './modules/layout'

export default Module({
    modules: {
        conf,
        socket,
        layout,
        sysPanel,
        stdoutPanel,
        stderrPanel,
    },
    providers: {
        ws
    },
    signals: {
        openws: actions.openws,
        sendSigTerm: ctx => ctx.ws.send("sigterm")
    }
});

