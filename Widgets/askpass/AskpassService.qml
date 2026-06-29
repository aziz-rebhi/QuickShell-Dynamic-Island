import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
  id: root

  property var _queue: []
  property bool _writing: false

  property var pendingRequest: null

  property IpcHandler _ipc: IpcHandler {
    target: "askpass"

    function prompt(prompt: string, fifoPath: string): void {
      root._queue = [];
      root._writing = false;
      root._queue.push({prompt: prompt, fifoPath: fifoPath});
      root._syncPending();
    }
  }

  function _syncPending() {
    pendingRequest = _queue.length > 0 ? _queue[0] : null;
  }

  function submit(password: string): void {
    if (_writing || _queue.length === 0) return;
    _writing = true;
    var req = _queue[0];
    writeFifo(req.fifoPath, password);
  }

  function cancel(): void {
    if (_writing || _queue.length === 0) return;
    _writing = true;
    var req = _queue[0];
    writeFifo(req.fifoPath, "\n");
  }

  function writeFifo(fifoPath: string, content: string): void {
    var qmlCode = 'import QtQuick; import Quickshell.Io; Process { ' +
      'command: ["sh", "-c", ' + JSON.stringify('printf "%s\\n" "$PASS" > "$1"') +
      ', "--", ' + JSON.stringify(fifoPath) + ']; ' +
      'environment: {"PASS": ' + JSON.stringify(content) + '}' +
      '}';
    var w = Qt.createQmlObject(qmlCode, root);
    if (!w) {
      console.log("askpass: failed to create write process");
      root._queue.shift();
      root._syncPending();
      root._writing = false;
      return;
    }
    w.exited.connect(function(exitCode) {
      if (exitCode !== 0)
        console.log("askpass: writeFifo exited with code", exitCode);
      w.destroy();
      root._queue.shift();
      root._syncPending();
      root._writing = false;
    });
    w.running = true;
  }
}
