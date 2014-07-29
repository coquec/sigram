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

Item {
    id: msg_media
    width: 100
    height: 62

    property bool isPhoto: Telegram.messageIsPhoto(msgId)
    property int msgId
    property bool out: false

    Connections {
        target: Telegram
        onMsgFileDownloading: {
            if( msgId != msgId )
                return

            p_bar.percent = percent
            p_bar.visible = true
            f_indicator.start()
        }
        onMsgFileDownloaded: {
            if( msgId != msgId )
                return

            p_bar.visible = false
            f_indicator.stop()
            f_img.path = Telegram.messageMediaFile(msgId)
        }
    }

    Image {
        id: f_img
        anchors.fill: parent
        sourceSize: Qt.size(width,height)
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        clip: true
        source: path.length==0? "" : "file://" + path

        property string path: Telegram.messageMediaFile(msgId)

        onPathChanged: {
            if( path.length == 0 )
                return

            var sz = Gui.imageSize(path)

            var item_ratio = msg_media.width/msg_media.height
            var img_ratio = sz.width/sz.height

            if( item_ratio > img_ratio ) {
                sourceSize.width = msg_media.width
                sourceSize.height = msg_media.width/img_ratio
            } else {
                sourceSize.width = msg_media.height*img_ratio
                sourceSize.height = msg_media.height
            }
        }
    }

    Indicator {
        id: f_indicator
        anchors.fill: parent
    }

    Text {
        id: not_support_text
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("Video and Audio files not supported yet.")
        visible: !Telegram.messageIsPhoto(msgId)
    }

    ProgressBar {
        id: p_bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: false
        height: 15
        color: msg_media.out? "#0d7080" : "#B6B6B6"
        topColor: msg_media.out? "#33B7CC" : "#E6E6E6"
    }

    MouseArea {
        anchors.fill: parent
        visible: f_img.path.length != 0
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (mouse.button == Qt.RightButton) {
                msg_media.showMenu()
            } else {
                var obj = flipMenu.show(limoo_component)
                obj.source = f_img.path
                mainFrame.focus = true
            }
        }
    }

    Component {
        id: limoo_component
        LimooImageComponent {
            width: chatFrame.chatView.width*3/4
            onRightClick: showMenu()
        }
    }

    function showMenu() {
        var acts = [ qsTr("Copy"), qsTr("Save as") ]

        var res = Gui.showMenu( acts )
        switch( res ) {
        case 0:
            Gui.copyFile(f_img.path)
            break;
        case 1:
            Gui.saveFile(f_img.path)
            break;
        }
    }
}
