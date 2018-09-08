export const ondisconnected = ctx => {
    ctx.state.set("socket.connected", false)
}

export const onconnected = ctx => {
    ctx.state.set("socket.connected", true)
}

export const onmessage = ({props, state, controller}) => {
    controller.getSignal(props.action)(props.payload)
}

export const openws = ctx => {
    ctx.ws.open(ctx.props)
}

export function sigterm({ ws }) {
    ws.send(JSON.stringify({
        action: 'sigterm',
        payload: {}
    }))
}

export function start({ ws }) {
    ws.send(JSON.stringify({
        action: 'runScript',
        payload: {
            id: 1 // selected script
        }
    }))
}

