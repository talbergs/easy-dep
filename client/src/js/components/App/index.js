import React from "react"
import { connect } from "@cerebral/react"
import { state, signal } from "cerebral/tags"
import OutputPanel from "../OutputPanel"
import ConfEditor from "../ConfEditor"
import Hook from "../Hook"

export default connect({
        online: state`socket.connected`,
        hooks: state`conf.obj.hooks`,
        layout: state`layout`,
        showConf: signal`layout.showConf`,
        showOutput: signal`layout.showOutput`,
        sigtermVisible: state`layout.sigtermVisible`,
        sendSigTerm: signal`sendSigTerm`,
        replVisible: state`layout.replVisible`,
        showRepl: signal`layout.toggleRepl`,
        onInputRepl: signal`layout.onInputRepl`,
        submitRepl: signal`layout.submitRepl`,
        replInputValue: state`layout.replInputValue`,
    },
    function App({
        online,
        hooks,
        layout,
        showConf,
        showOutput,
        sigtermVisible,
        sendSigTerm,
        showRepl,
        replVisible,
        onInputRepl,
        submitRepl,
        replInputValue,
    }) {
        return <div>
            <div className="panel top">
                <button onClick={e => showConf()} disabled={!online}>Conf editor</button>
                <button onClick={e => showOutput()}>Output panels</button>
                <button onClick={e => sendSigTerm()} disabled={!sigtermVisible}>Sigterm</button>
                <button onClick={e => showRepl()}>Repl</button>
                <button disabled="disabled">Queue [todo]</button>
            </div>

            { layout.outputVisible && [
                    <OutputPanel linesPath="stdoutPanel.lines" className="panel stdout center center-top scroll-y" />,
                    <OutputPanel linesPath="stderrPanel.lines" className="panel stderr center center-bottom scroll-y" />
                ] }

            { layout.confVisible && <ConfEditor className="panel center scroll-y" /> }

            <div className="panel left">{
                hooks.map((_, i) => <Hook key={i} index={i} />)
            }</div>

            <div className="panel corner">
                { online ? 'online' : 'offline' }
            </div>

            { replVisible &&
               <div>
                <input value={replInputValue} onChange={e => onInputRepl({value: e.target.value})} />
                <button onClick={e => submitRepl()}>submit</button>
                </div>
             || <OutputPanel linesPath="sysPanel.lines" className="panel footer scroll-y" />
            }
        </div>
    }
);

