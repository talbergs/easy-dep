import React from "react";
import { connect } from "@cerebral/react";
import { state, signal, props } from "cerebral/tags";
import Line from "../Line";

export default connect({
    lines: state`${props`linesPath`}`
}, class OutputPanel extends React.Component {

    handleOnScroll(e) {
        const {scrollTop} = e.currentTarget

        const diff = this.prevScrollTop - scrollTop
        if (diff > 0) {
            // scrolled up
            this.frozenAutoscroll = true
        } else {
            // scrolled down
            this.frozenAutoscroll = false
        }

        this.prevScrollTop = scrollTop
    }

    scrollToBottom() {
        !this.frozenAutoscroll && this._node && this._node.scrollTo({
            top: this._node.scrollHeight,
            left: 0,
            behavior: 'smooth',
        })
    }

    render() {
        return <div
            ref={(el) => { this._node = el; }}
            onScroll={e => this.handleOnScroll(e)}
            className={ this.props.className }
        >{ this.props.lines.map(l => <Line scrollToBottom={this.scrollToBottom.bind(this)} {...l} />) }</div>
    }
});

