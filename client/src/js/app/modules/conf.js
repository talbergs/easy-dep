import { Module } from "cerebral";

export default Module({
    state: {
        str: '{}',
        obj: {
            hooks: []
        },
    },
    signals: {
        invokeScript: ctx => {
            ctx.ws.send('invokeScriptAtIndex', ctx.props.index)
        },
        updateConf: ctx => {
            ctx.ws.send('updateConf', ctx.props.data)
        },
        loadConf: ctx => {
            ctx.ws.send('loadConf')
        },
        gotStr: ctx => {
            const conf = JSON.parse(ctx.props.data)
            ctx.state.set('conf.str', ctx.props.data)
            ctx.state.set('conf.obj', conf)
        },
    }
});


