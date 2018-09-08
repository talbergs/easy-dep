import { Provider } from 'cerebral'

export default Provider({
    send(action, payload = {}) {
        self.ws.send(JSON.stringify({
            action,
            payload,
        }))
    },
    open({ws, onmessage, onopen = '', onclose = '', reconnect = false}) {
        self.ws = new WebSocket(ws)
        onclose && (self.ws.onclose = _ => {

            reconnect && setTimeout(function() {this.context.controller.getSignal("openws")({
                ws,
                onmessage,
                onopen,
                onclose,
                reconnect,
            })}.bind(this), 10000)

            this.context.controller.getSignal(onclose)()
        })

        onopen && (self.ws.onopen = _ => {
            this.context.controller.getSignal(onopen)()
        })

        self.ws.onmessage = e => {
            const d = JSON.parse(e.data)
            this.context.controller
                .getSignal(onmessage)(d)
        }
    }
})

