import QtQuick
import Quickshell
import Caelestia.Config

Scope {
    id: root
    property bool failed: false
    Connections {
        target: GlobalConfig
        function onUnknownOption(key: string, screen: string): void {
            console.error("CONFIG_CHECK_FAILED unknown option: " + key);
            root.failed = true;
        }
        function onLoadFailed(error: string, screen: string): void {
            console.error("CONFIG_CHECK_FAILED " + error);
            root.failed = true;
        }
    }
    Timer { interval: 100; running: true; onTriggered: GlobalConfig.reload() }
    Timer {
        interval: 1000
        running: true
        onTriggered: {
            if (!root.failed) console.log("CONFIG_CHECK_PASSED");
            Qt.quit();
        }
    }
}
