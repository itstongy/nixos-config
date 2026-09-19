import signal
import subprocess
import sys

from PySide6.QtCore import Qt
from PySide6.QtGui import QColor, QIcon, QPainter, QPixmap
from PySide6.QtWidgets import QApplication, QMenu, QSystemTrayIcon

app = QApplication(sys.argv)
app.setQuitOnLastWindowClosed(False)
keyboard = None


def show_keyboard():
    global keyboard
    if keyboard is None or keyboard.poll() is not None:
        keyboard = subprocess.Popen([
            sys.argv[1], "-H", "360", "-L", "360", "--fn", "sans 22"
        ])
    else:
        keyboard.send_signal(signal.SIGUSR2)


def hide_keyboard():
    if keyboard is not None and keyboard.poll() is None:
        keyboard.send_signal(signal.SIGUSR1)


def cleanup():
    if keyboard is not None and keyboard.poll() is None:
        keyboard.terminate()


icon = QPixmap(24, 24)
icon.fill(Qt.GlobalColor.transparent)
painter = QPainter(icon)
painter.fillRect(2, 5, 20, 14, QColor("#d3c6aa"))
for y in (8, 12):
    for x in (5, 9, 13, 17):
        painter.fillRect(x, y, 2, 2, QColor("#2d353b"))
painter.fillRect(7, 16, 10, 1, QColor("#2d353b"))
painter.end()
tray = QSystemTrayIcon(QIcon(icon), app)
tray.setToolTip("On-screen keyboard")
menu = QMenu()
menu.addAction("Show keyboard", show_keyboard)
menu.addAction("Hide keyboard", hide_keyboard)
tray.setContextMenu(menu)
tray.activated.connect(
    lambda reason: show_keyboard()
    if reason == QSystemTrayIcon.ActivationReason.Trigger else None
)
app.aboutToQuit.connect(cleanup)
tray.show()
sys.exit(app.exec())
