import { Module } from "cerebral";

export default Module({
    state: {
        sigtermVisible: false,
        confVisible: false,
        outputVisible: true,
        replVisible: false,
        replInputValue: '',
    },
    signals: {
        onInputRepl: ctx => {
            ctx.state.set('layout.replInputValue', ctx.props.value)
        },
        submitRepl: ctx => {
            const val = ctx.state.get('layout.replInputValue')
            console.log(val)
        },
        showOutput: [
            ctx => { ctx.state.set('layout.confVisible', false) },
            ctx => { ctx.state.set('layout.outputVisible', true) },
        ],
        showConf: [
            ctx => { ctx.state.set('layout.confVisible', true) },
            ctx => { ctx.state.set('layout.outputVisible', false) },
        ],
        toggleRepl: [
            ctx => { ctx.state.toggle('layout.replVisible') },
        ],
    }
});

