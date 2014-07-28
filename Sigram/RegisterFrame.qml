/*
    Copyright (C) 2014 Sialan Labs
    http://labs.sialan.org

    Sigram is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sigram is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import org.sialan.telegram 1.0

Item {
    id: register_frame
    width: 100
    height: 62

    Connections {
        target: tgClient
        onAuthCheckPhoneAnswer: {
            indicator.visible = false
            phone.visible = false
            code.visible = false
            user.visible = false

            if( phoneRegistered )
                code.visible = true
            else
                user.visible = true

            tgClient.authSendCode()
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 10

        Image {
            width: 100
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize: Qt.size(width,height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: "files/icon.png"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 26
            font.family: globalNormalFontFamily
            font.weight: Font.Light
            color: "#333333"
            text: "Sigram"
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20
        }

        RegisterFramePhone {
            id: phone
            anchors.left: parent.left
            anchors.right: parent.right
            height: 300
            onGoEmitted: {
                indicator.visible = true
                phone.visible = false
            }
        }

        RegisterFrameCode {
            id: code
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
        }

        RegisterFrameUser {
            id: user
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
        }

        Indicator {
            id: indicator
            anchors.left: parent.left
            anchors.right: parent.right
            height: 200
            source: "files/indicator_light.png"
            visible: false
            onVisibleChanged: {
                if( visible )
                    start()
                else
                    stop()
            }
        }
    }
}
