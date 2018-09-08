import { Module } from "cerebral";

export default Module({
    state: {
        lines: []
    },
    signals: {
        addLine: ctx => ctx.state.push('sysPanel.lines', ctx.props)
    }
});


