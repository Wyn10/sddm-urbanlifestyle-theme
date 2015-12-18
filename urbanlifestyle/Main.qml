/**
 * Urban LifeStyle SDDM Theme
 * Copyright (C) 2015  Alfredo Ramos <alfredo.ramos@yandex.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.3
import SddmComponents 2.0

Rectangle {
	width: 640
	height: 480

	TextConstants {
		id: textConstants
	}

	Connections {
		target: sddm

		onLoginSucceeded: {
			errorMessage.color = "#005398"
			errorMessage.text = textConstants.loginSucceeded
		}

		onLoginFailed: {
			errorMessage.color = "#b00000"
			errorMessage.text = textConstants.loginFailed
			password.text = ""
			password.focus = true
		}
	}

	Repeater {
		model: screenModel

		Background {
			x: geometry.x
			y: geometry.y
			anchors.fill: parent
			width: geometry.width
			height: geometry.height
			source: config.background
			fillMode: Image.PreserveAspectFit

			onStatusChanged: {
				if (status == Image.Error && source != config.defaultBackground) {
					source = config.defaultBackground
				}
			}
		}
	}

	Rectangle {
		property variant geometry: screenModel.geometry(screenModel.primary)
		x: geometry.x
		y: geometry.y
		width: geometry.width
		height: geometry.height
		color: "transparent"

		Rectangle {
			color: "transparent"
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.leftMargin: 60
			anchors.topMargin: 60
			width: Math.max(320, mainColumn.implicitWidth + 10)
			height: Math.max(320, mainColumn.implicitHeight + 10)
			border.color: "#ababab"
			border.width: 1
			radius: 6

			Column {
				id: mainColumn
				anchors.centerIn: parent
				spacing: 12

				Column {
					width: parent.width
					spacing: 4

					Text {
						id: lblName
						width: parent.width
						text: textConstants.userName
						color: "#555"
						font.bold: true
						font.pixelSize: 12
					}

					TextBox {
						id: name
						width: parent.width
						height: 30
						text: userModel.lastUser
						font.pixelSize: 14
						color: "#99ffffff" /* ARGB */
						focusColor: "#69d6ac"
						hoverColor: "#69d6ac"

						KeyNavigation.backtab: rebootButton
						KeyNavigation.tab: password

						Keys.onPressed: {
							if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
								sddm.login(name.text, password.text, session.index)
								event.accepted = true
							}
						}
					}
				}

				Column {
					width: parent.width
					spacing: 4

					Text {
						id: lblPassword
						width: parent.width
						text: textConstants.password
						color: "#555"
						font.bold: true
						font.pixelSize: 12
					}

					PasswordBox {
						id: password
						width: parent.width
						height: 30
						font.pixelSize: 14
						color: "#99ffffff" /* ARGB */
						focusColor: "#ebaf1d"
						hoverColor: "#ebaf1d"
						tooltipBG: "lightgrey"
						
                        // This hack courtesy of our friends at KDE: https://quickgit.kde.org/?p=plasma-workspace.git&a=blobdiff&h=275801dc5539a342276e4c9f6817ff3c80f7d020&hp=31423628c9a847344c0e3e27b98b73b6042cefe6&hb=dfc4b8b2a0e2b012f68f0192e29081ee230e8c03&f=lookandfeel%2Fcontents%2Floginmanager%2FMain.qml
                        // focus works in qmlscene
                        // but this seems to be needed when loaded from SDDM
                        // I don't understand why, but we have seen this before in the old lock screen
                        focus: true
                        Timer {
                            interval: 200
                            running: true
                            onTriggered: password.forceActiveFocus()
                        }

						KeyNavigation.backtab: name
						KeyNavigation.tab: session

						Keys.onPressed: {
							if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
								sddm.login(name.text, password.text, session.index)
								event.accepted = true
							}
						}
					}
				}

				Row {
					spacing: 4
					width: parent.width / 2
					z: 100

					Column {
						z: 100
						width: parent.width * 1.3
						spacing: 4
						anchors.bottom: parent.bottom

						Text {
							id: lblSession
							width: parent.width
							text: textConstants.session
							wrapMode: TextEdit.WordWrap
							color: "#555"
							font.bold: true
							font.pixelSize: 12
						}

						ComboBox {
							id: session
							width: parent.width
							height: 30
							font.pixelSize: 14
							color: "#99ffffff" /* ARGB */
							focusColor: "#85c92d"
							hoverColor: "#85c92d"

							arrowIcon: "resources/images/angle-down.png"

							model: sessionModel
							index: sessionModel.lastIndex

							KeyNavigation.backtab: password
							KeyNavigation.tab: layoutBox
						}
					}

					Column {
						z: 101
						width: parent.width * 0.7
						spacing: 4
						anchors.bottom: parent.bottom

						Text {
							id: lblLayout
							width: parent.width
							text: textConstants.layout
							wrapMode: TextEdit.WordWrap
							color: "#555"
							font.bold: true
							font.pixelSize: 12
						}

						LayoutBox {
							id: layoutBox
							width: parent.width
							height: 30
							font.pixelSize: 14
							color: "#99ffffff" /* ARGB */
							focusColor: "#31d8de"
							hoverColor: "#31d8de"

							arrowIcon: "resources/images/angle-down.png"

							KeyNavigation.backtab: session
							KeyNavigation.tab: loginButton
						}
					}
				}

				Column {
					width: parent.width

					Text {
						id: errorMessage
						anchors.horizontalCenter: parent.horizontalCenter
						text: textConstants.prompt
						color: "#555"
						font.pixelSize: 10
					}
				}

				Row {
					spacing: 4
					anchors.horizontalCenter: parent.horizontalCenter
					property int btnWidth: Math.max( loginButton.implicitWidth, shutdownButton.implicitWidth, rebootButton.implicitWidth, 80) + 8

					Button {
						id: loginButton
						text: textConstants.login
						width: parent.btnWidth
						color: "#08c"
						activeColor: "#08c"

						onClicked: sddm.login(name.text, password.text, session.index)

						KeyNavigation.backtab: layoutBox
						KeyNavigation.tab: shutdownButton
					}

					Button {
						id: shutdownButton
						text: textConstants.shutdown
						width: parent.btnWidth
						color: "#d11"
						activeColor: "#d11"

						onClicked: sddm.powerOff()

						KeyNavigation.backtab: loginButton
						KeyNavigation.tab: rebootButton
					}

					Button {
						id: rebootButton
						text: textConstants.reboot
						width: parent.btnWidth
						color: "#ff4f14"
						activeColor: "#ff4f14"

						onClicked: sddm.reboot()

						KeyNavigation.backtab: shutdownButton
						KeyNavigation.tab: name
					}
				}
			}
		}
	}

	Component.onCompleted: {
		if (name.text == "")
			name.focus = true
		else
			password.focus = true
	}
}
