import React from "react";
import { connect } from "@cerebral/react";
import { state, signal } from "cerebral/tags";
import Convert from 'ansi-to-html'

const convert = new Convert({
    fg: '#FFF',
    bg: '#000',
    newline: true,
    escapeXML: true,
    stream: false
});

export default connect({},
  class Line extends React.Component {

      render() {

          this.props.scrollToBottom()

          const lineHtml = convert.toHtml(this.props.line)
              .replace(
                  /^[ \t]+/gm, x =>
                  new Array(x.length + 1)
                  .join('&nbsp;')
              )
          return <div
            key={this.props.id}
            className={this.props.className}
            dangerouslySetInnerHTML={{__html:lineHtml}}
          />
        }
    }
);

