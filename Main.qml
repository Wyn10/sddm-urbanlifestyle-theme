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

import QtQuick 2.0
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
			errorMessage.color = "steelblue"
			errorMessage.text = textConstants.loginSucceeded
		}

		onLoginFailed: {
			errorMessage.color = "red"
			errorMessage.text = textConstants.loginFailed
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
			width: Math.max(310, mainColumn.implicitWidth + 10)
			height: Math.max(310, mainColumn.implicitHeight + 10)
			border.color: "#ababab"
			border.width: 1
			radius: 7

			Column {
				id: mainColumn
				anchors.centerIn: parent
				spacing: 12

				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					verticalAlignment: Text.AlignVCenter
					width: parent.width
					height: text.implicitHeight
					color: "black"
					text: textConstants.welcomeText.arg(sddm.hostName)
					wrapMode: Text.WordWrap
					font.pixelSize: 24
					elide: Text.ElideRight
					horizontalAlignment: Text.AlignHCenter
				}

				Column {
					width: parent.width
					spacing: 4
					Text {
						id: lblName
						width: parent.width
						text: textConstants.userName
						font.bold: true
						font.pixelSize: 12
					}

					TextBox {
						id: name
						width: parent.width
						height: 30
						text: userModel.lastUser
						font.pixelSize: 14

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
						font.bold: true
						font.pixelSize: 12
					}

					PasswordBox {
						id: password
						width: parent.width
						height: 30
						font.pixelSize: 14
						tooltipBG: "lightgrey"

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
							font.bold: true
							font.pixelSize: 12
						}

						ComboBox {
							id: session
							width: parent.width
							height: 30
							font.pixelSize: 14

							arrowIcon: "angle-down.png"

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
							font.bold: true
							font.pixelSize: 12
						}

						LayoutBox {
							id: layoutBox
							width: parent.width
							height: 30
							font.pixelSize: 14

							arrowIcon: "angle-down.png"

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