import { Module } from "cerebral";

export default Module({
    state: {
        lines: []
    },
    signals: {
        addLine: [
            ctx => ctx.state.set('layout.sigtermVisible', true),
            ctx => ctx.state.push('stdoutPanel.lines', ctx.props),
        ]
    }
});


