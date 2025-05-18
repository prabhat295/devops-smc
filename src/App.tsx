import { useState, useRef } from 'react'
import { Container, Box, Typography, Button, List, ListItem, ListItemText, IconButton, Paper } from '@mui/material'
import { Mic, Stop, PlayArrow, Delete } from '@mui/icons-material'
import './App.css'

interface VoiceNote {
  id: string;
  blob: Blob;
  timestamp: Date;
}

function App() {
  const [isRecording, setIsRecording] = useState(false);
  const [voiceNotes, setVoiceNotes] = useState<VoiceNote[]>([]);
  const [currentAudio, setCurrentAudio] = useState<HTMLAudioElement | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream);
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) {
          chunksRef.current.push(e.data);
        }
      };

      mediaRecorder.onstop = () => {
        const audioBlob = new Blob(chunksRef.current, { type: 'audio/webm' });
        const newVoiceNote: VoiceNote = {
          id: Date.now().toString(),
          blob: audioBlob,
          timestamp: new Date(),
        };
        setVoiceNotes((prev) => [...prev, newVoiceNote]);
        stream.getTracks().forEach(track => track.stop());
      };

      mediaRecorder.start();
      setIsRecording(true);
    } catch (error) {
      console.error('Error accessing microphone:', error);
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && isRecording) {
      mediaRecorderRef.current.stop();
      setIsRecording(false);
    }
  };

  const playVoiceNote = (voiceNote: VoiceNote) => {
    if (currentAudio) {
      currentAudio.pause();
      currentAudio.currentTime = 0;
    }

    const audioUrl = URL.createObjectURL(voiceNote.blob);
    const audio = new Audio(audioUrl);
    setCurrentAudio(audio);
    audio.play();
  };

  const deleteVoiceNote = (id: string) => {
    setVoiceNotes((prev) => prev.filter((note) => note.id !== id));
  };

  return (
    <Container maxWidth="sm">
      <Box sx={{ my: 4, textAlign: 'center' }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Voice Notes
        </Typography>
        
        <Paper elevation={3} sx={{ p: 2, mb: 3 }}>
          <Button
            variant="contained"
            color={isRecording ? "error" : "primary"}
            onClick={isRecording ? stopRecording : startRecording}
            startIcon={isRecording ? <Stop /> : <Mic />}
            sx={{ mr: 2 }}
          >
            {isRecording ? "Stop Recording" : "Start Recording"}
          </Button>
        </Paper>

        <List>
          {voiceNotes.map((note) => (
            <ListItem
              key={note.id}
              secondaryAction={
                <Box>
                  <IconButton edge="end" onClick={() => playVoiceNote(note)}>
                    <PlayArrow />
                  </IconButton>
                  <IconButton edge="end" onClick={() => deleteVoiceNote(note.id)}>
                    <Delete />
                  </IconButton>
                </Box>
              }
            >
              <ListItemText
                primary={`Voice Note ${note.id}`}
                secondary={note.timestamp.toLocaleString()}
              />
            </ListItem>
          ))}
        </List>
      </Box>
    </Container>
  )
}

export default App
