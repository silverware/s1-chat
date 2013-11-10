Chat.VideoChat = Em.Object.extend
  # RTCPeerConnection
  peerConnection: null

  init: (data) ->
    if not @peerConnection
      @startVideo false, data.username
    if data.payload.sdp
      @peerConnection.setRemoteDescription(new RTCSessionDescription(data.payload.sdp))
    else if data.payload.candidate
      @peerConnection.addIceCandidate(new RTCIceCandidate(data.payload.candidate))

  startVideo: (isCaller, receiver) ->
    pc_config = "iceServers": ["url": "stun:stun.l.google.com:19302"]
    @peerConnection = new RTCPeerConnection(pc_config)
    @peerConnection.onicecandidate = (evt) =>
      Chat.sendMsg
        type: "video"
        receiver: receiver
        payload:
          candidate: evt.candidate

    @peerConnection.onaddstream = (evt) ->
      console.log("stream added", evt)
      $("#remoteview").attr("src", URL.createObjectURL(evt.stream))
      $("#remoteview").get(0).play()

    navigator.webkitGetUserMedia {audio: true, video: true}, (stream) =>
      $("#selfview").attr "src", URL.createObjectURL(stream)
      $("#selfview").get(0).play()
      @peerConnection.addStream stream

      if isCaller
        console.debug("I am caller.")
        @peerConnection.createOffer (desc) =>
            @peerConnection.setLocalDescription desc
            Chat.sendMsg
                type: "video"
                receiver: receiver
                payload:
                  sdp: desc
      else
        console.debug("I am callee.")
        @peerConnection.createAnswer (desc) =>
          @peerConnection.setLocalDescription desc
          Chat.sendMsg
              type: "video"
              receiver: receiver
              payload:
                sdp: desc
