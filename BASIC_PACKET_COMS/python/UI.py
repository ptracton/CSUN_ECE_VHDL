import PySide6
import PySide6.QtWidgets

import UI_CentralWidget


class UI(PySide6.QtWidgets.QMainWindow):
    """Top level UI class."""

    def __init__(self, parent=None):
        """UI Constructor."""
        super(UI, self).__init__(parent)

        # Create Main Window Elements
        self.statusBar().showMessage("Status Bar")
        self.setWindowTitle("BASIC COMS PACKETS")

        # Create our central widget
        self.centralWidget = UI_CentralWidget.UI_CentralWidget()
        self.setCentralWidget(self.centralWidget)

        # Display
        self.show()
