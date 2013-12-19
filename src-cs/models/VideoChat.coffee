navigator.getMedia = ( navigator.getUserMedia ||
                       navigator.webkitGetUserMedia ||
                       navigator.mozGetUserMedia ||
                       navigator.msGetUserMedia)



Chat.VideoChat = Em.Object.extend

  username: ""
  # RTCPeerConnection
  peerConnection: null
  isCaller: true
  streamRemote: null
  streamSelf: null

  init: ->
    @_super()
    @startVideo()

  huhu: (data) ->
    if data?.payload?.sdp
      @peerConnection.setRemoteDescription(new RTCSessionDescription(data.payload.sdp))
    else if data?.payload?.candidate
      @peerConnection.addIceCandidate(new RTCIceCandidate(data.payload.candidate))


  startVideo: ->
    pc_config = "iceServers": ["url": "stun:stun.l.google.com:19302"]
    @peerConnection = new RTCPeerConnection(pc_config)
    @peerConnection.onicecandidate = (evt) =>
      Chat.sendMsg
        type: "video"
        receiver: @username
        payload:
          candidate: evt.candidate

    @peerConnection.onaddstream = (evt) =>
      console.log("stream added", evt)
      @set "streamRemote", evt.stream

    errorCallback = (error) =>
      console.debug "error occurred: " + error 

    successCallback = (stream) =>
      @set "streamSelf", stream
      @peerConnection.addStream stream

      if @isCaller
        console.debug("I am caller.")
        @peerConnection.createOffer ((desc) =>
            @peerConnection.setLocalDescription desc
            Chat.sendMsg
                type: "video"
                receiver: @username
                payload:
                  sdp: desc
        ), errorCallback
      else
        console.debug("I am callee.")
        @peerConnection.createAnswer (desc) =>
          @peerConnection.setLocalDescription desc
          Chat.sendMsg
              type: "video"
              receiver: @username
              payload:
                sdp: desc
        , errorCallback
    
    navigator.getMedia {audio: true, video: true}, successCallback, errorCallback

