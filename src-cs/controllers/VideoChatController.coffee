if typeof webkitRTCPeerConnection != "undefined"
    RTCPeerConnection = webkitRTCPeerConnection
else if typeof mozRTCPeerConnection != "undefined"
    RTCPeerConnection = mozRTCPeerConnection


Chat.VideoChatController = Em.ObjectController.extend
  title: "Video Chat"


