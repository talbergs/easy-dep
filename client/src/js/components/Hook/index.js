import React from "react";
import { connect } from "@cerebral/react";
import { state, signal, props } from "cerebral/tags";
import Line from "../Line";

export default connect({
    hook: state`conf.obj.hooks.${props`index`}`,
    invokeScript: signal`conf.invokeScript`,
}, function Hook({hook, invokeScript, index}) {
    let str = hook.name
    if (str === undefined) {
        str = hook.path + hook.script.bin + hook.script.args.join(' ')
    }

    return <button onClick={e => invokeScript({index})}>
        { str }
    </button>
});

