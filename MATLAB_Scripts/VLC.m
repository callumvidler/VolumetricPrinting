%
%  VLC.m
%
%  Created by Léa Strobino.
%  Copyright 2018. All rights reserved.
%

classdef VLC < matlab.mixin.SetGet
  
  properties (Constant)
    Port = 4212;
  end
  
  properties (SetAccess = private)
    Version
    Status
    Current
    Playlist
  end
  
  properties
    Loop
    Repeat
    Random
    Fullscreen
    Rate
    Volume
  end
  
  properties (Access = private)
    requestURL
    password = 'QvGkByH97AOxRvhP';
  end
  
  methods
    
    function this = VLC()
      persistent retry %#ok<*NASGU>
      this.requestURL = sprintf('http://127.0.0.1:%d/request.json',this.Port);
      try
        this.set('Loop','off','Repeat','off','Random','off','Fullscreen','off','Rate',1);
      catch e
        if isempty(retry) && ~isempty([strfind(e.message,'java.net.ConnectException') strfind(e.message,'java.net.SocketTimeoutException')])
          args = sprintf('--extraintf http --http-host 127.0.0.1 --http-port %d --http-password "%s" --http-src "%s"',...
            this.Port,this.password,fileparts(mfilename('fullpath')));
          if ispc
            if exist('C:\Program Files (x86)\VideoLAN\VLC\vlc.exe','file')
              [~,~] = dos(['"C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" ' args ' &']);
            else
              [~,~] = dos(['"C:\Program Files\VideoLAN\VLC\vlc.exe" ' args ' &']);
            end
          elseif ismac
            [~,~] = unix(['open -a VLC --args ' args ' 2> /dev/null']);
          end
          pause(3);
          retry = true;
          this = VLC();
        else
          retry = [];
          error('VLC:CommunicationError','Unable to communicate with VLC.');
        end
      end
      retry = [];
    end
    
    % add 'file' to the playlist
    function add(this,file)
      this.request(['c=enqueue&v=' this.urlencode(this.getFile(file))]);
    end
    
    % resume playback or play 'file'
    function play(this,file)
      if nargin > 1
        this.request(['c=add&v=' this.urlencode(this.getFile(file))]);
      else
        this.request('c=play');
      end
    end
    
    % pause playback
    function pause(this)
      this.request('c=pause');
    end
    
    % stop playback
    function stop(this)
      this.request('c=stop');
    end
    
    % play next track
    function next(this)
      this.request('c=next');
    end
    
    % play previous track
    function prev(this)
      this.request('c=prev');
    end
    
    % seek to position (in seconds)
    function seek(this,position)
      this.request(sprintf('c=seek&v=%.0f',position));
    end
    
    % move item ID 'x' in the playlist after item ID 'y'
    function move(this,x,y)
      id = [this.Playlist.Content.ID];
      if any(x == id) && any(y == id)
        this.request(sprintf('c=move&v=%.0f,%.0f',x,y));
      else
        error('VLC:InvalidTrackID','Invalid track ID.');
      end
    end
    
    % remove item ID 'x' from the playlist
    function remove(this,x)
      if any(x == [this.Playlist.Content.ID])
        this.request(sprintf('c=delete&v=%.0f',x));
      else
        error('VLC:InvalidTrackID','Invalid track ID.');
      end
    end
    
    % empty the playlist
    function clear(this)
      this.request('c=clear');
    end
    
    % quit VLC and delete object
    function quit(this)
      this.request('c=quit');
      delete(this);
    end
    
    function v = get.Version(this)
      v = this.getStatus().version;
    end
    
    function s = get.Status(this)
      s = this.getStatus().status;
    end
    
    function c = get.Current(this)
      r = this.getStatus();
      if isfield(r,'current')
        c = r.current;
        c.Meta = struct();
        m = fieldnames(r.current.Meta);
        for i = 1:length(m)
          n = lower(m{i});
          j = find(n == ' ' | n == '_');
          try %#ok<TRYNC>
            n([1 j+1]) = upper(n([1 j+1]));
          end
          n(j) = [];
          c.Meta.(n) = r.current.Meta.(m{i});
        end
      else
        c = [];
      end
    end
    
    function p = get.Playlist(this)
      p = this.getStatus().playlist;
    end
    
    function v = get.Loop(this)
      v = this.getValue('loop');
    end
    
    function set.Loop(this,loop)
      this.setValue('loop',loop);
    end
    
    function v = get.Repeat(this)
      v = this.getValue('repeat');
    end
    
    function set.Repeat(this,repeat)
      this.setValue('repeat',repeat);
    end
    
    function v = get.Random(this)
      v = this.getValue('random');
    end
    
    function set.Random(this,random)
      this.setValue('random',random);
    end
    
    function v = get.Fullscreen(this)
      v = this.getValue('fullscreen');
    end
    
    function set.Fullscreen(this,fullscreen)
      this.setValue('fullscreen',fullscreen);
    end
    
    function v = get.Rate(this)
      v = this.getStatus().rate;
    end
    
    function set.Rate(this,rate)
      this.request(sprintf('c=rate&v=%.6f',rate));
    end
    
    function v = get.Volume(this)
      v = this.getStatus().volume;
    end
    
    function set.Volume(this,volume)
      this.request(sprintf('c=volume&v=%.0f',volume));
    end
    
  end
  
  methods (Access = private)
    
    function f = getFile(~,f)
      [p,n,e] = fileparts(f);
      if isempty(p)
        p = cd();
      end
      f = fullfile(p,[n e]);
      h = fopen(f);
      if h > 0
        fclose(h);
      else
        error('VLC:FileNotFound','"%s": no such file.',f);
      end
    end
    
    function s = getStatus(this)
      persistent t json
      if isempty(t) || toc(t) > .5
        json = json_decode(this.request());
        t = tic();
      end
      s = json;
    end
    
    function v = getValue(this,c)
      if this.getStatus().(c)
        v = 'on';
      else
        v = 'off';
      end
    end
    
    function setValue(this,c,v)
      if strcmpi(v,'on')
        this.request(['c=' c '&v=on']);
      elseif strcmpi(v,'off')
        this.request(['c=' c '&v=off']);
      else
        throwAsCaller(MException('MATLAB:datatypes:InvalidEnumValueFor',...
          'Invalid enum value. Use one of these values: ''on'' | ''off''.'));
      end
    end
    
    function s = request(this,r)
      persistent authorization isc
      if isempty(authorization)
        authorization = ['Basic ' org.apache.commons.codec.binary.Base64.encodeBase64(uint8([':' this.password]))'];
        isc = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier();
      end
      try
        if nargin == 2
          url = java.net.URL([this.requestURL '?' r]);
        else
          url = java.net.URL(this.requestURL);
        end
        c = url.openConnection();
        c.setConnectTimeout(50);
        c.setReadTimeout(500);
        c.setRequestProperty('Authorization',authorization);
        if nargin == 2
          c.connect();
          c.getContentLength();
        else
          i = c.getInputStream();
          o = java.io.ByteArrayOutputStream();
          isc.copyStream(i,o);
          i.close();
          o.close();
          s = native2unicode(typecast(o.toByteArray()','uint8'),'UTF-8');
        end
      catch e
        if strcmp(e.identifier,'MATLAB:Java:GenericException')
          r = regexp(e.message,'\n([^\n]*)\n','tokens','once');
          error('VLC:SocketException',r{1});
        else
          rethrow(e);
        end
      end
    end
    
    function s = urlencode(~,s)
      s = char(java.net.URLEncoder.encode(s,'UTF-8'));
      s = strrep(s,'+','%20');
    end
    
  end
  
end
