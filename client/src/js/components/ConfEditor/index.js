import React from "react";
import { connect } from "@cerebral/react";
import { state, signal, props } from "cerebral/tags";
import Line from "../Line";

export default connect({
    confObj: state`conf.obj`,
    updateConf: signal`conf.updateConf`,
    resetJson: signal`conf.loadConf`,
}, class OutputPanel extends React.Component {

    resetJson() {
        this.props.resetJson()
    }

    saveJson() {
        this.props.updateConf({data: this.json})
    }

    onJsonInpChange(e) {
        this.json = e.target.value
    }

    render() {
        this.json = JSON.stringify(this.props.confObj, null, 4)

        return <div className={this.props.className}>
            <button onClick={e => this.saveJson()}>write to file</button>
            <button onClick={e => this.resetJson()}>reset</button>
            <textarea style={{
                width: '99%',
                height: '86%',
            }} defaultValue={this.json} onChange={this.onJsonInpChange.bind(this)} />
        </div>
    }
});

