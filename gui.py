#!/usr/bin/env python3
"""
EZVIZ Live Stream URL Generator
A simple GUI application to get live streaming URLs from EZVIZ devices
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext, filedialog
import requests
import json
import pyperclip
from datetime import datetime
import threading
import os

class EzvizStreamGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("EZVIZ Live Stream URL Generator")
        self.root.geometry("700x800")
        self.root.resizable(False, False)
        
        # Variables
        self.access_token = None
        self.area_domain = None
        self.token_expire_time = None
        
        # Style
        style = ttk.Style()
        style.theme_use('clam')
        
        self.create_widgets()
        
        # Bind keyboard shortcuts
        self.root.bind('<Control-v>', lambda e: self.paste_to_focused_entry())
        self.root.bind('<Control-s>', lambda e: self.save_config())
        self.root.bind('<Control-o>', lambda e: self.load_config())
        
        # Make entry fields focusable
        self.app_key_entry.focus_set()
        
    def create_widgets(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Title
        title_label = ttk.Label(main_frame, text="EZVIZ Live Stream URL Generator", 
                               font=('Helvetica', 16, 'bold'))
        title_label.grid(row=0, column=0, columnspan=2, pady=10)
        
        # API Credentials Section
        cred_frame = ttk.LabelFrame(main_frame, text="API Credentials", padding="10")
        cred_frame.grid(row=1, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=10)
        
        # Configure column weights for proper expansion
        cred_frame.columnconfigure(1, weight=1)
        
        # App Key
        ttk.Label(cred_frame, text="App Key:").grid(row=0, column=0, sticky=tk.W, pady=5)
        key_frame = ttk.Frame(cred_frame)
        key_frame.grid(row=0, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        
        self.app_key_entry = ttk.Entry(key_frame, width=50)
        self.app_key_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        self.paste_key_btn = ttk.Button(key_frame, text="Paste", width=8,
                                       command=lambda: self.paste_to_entry(self.app_key_entry))
        self.paste_key_btn.pack(side=tk.LEFT, padx=(5, 0))
        
        # App Secret
        ttk.Label(cred_frame, text="App Secret:").grid(row=1, column=0, sticky=tk.W, pady=5)
        secret_frame = ttk.Frame(cred_frame)
        secret_frame.grid(row=1, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        
        self.show_secret_var = tk.BooleanVar(value=False)
        self.app_secret_entry = ttk.Entry(secret_frame, width=40, show="*")
        self.app_secret_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        self.toggle_secret_btn = ttk.Button(secret_frame, text="Show", width=6,
                                           command=self.toggle_secret_visibility)
        self.toggle_secret_btn.pack(side=tk.LEFT, padx=(5, 0))
        
        self.paste_secret_btn = ttk.Button(secret_frame, text="Paste", width=8,
                                          command=lambda: self.paste_to_entry(self.app_secret_entry))
        self.paste_secret_btn.pack(side=tk.LEFT, padx=(5, 0))
        
        # Authentication button and status
        self.auth_button = ttk.Button(cred_frame, text="Authenticate", command=self.authenticate)
        self.auth_button.grid(row=2, column=0, columnspan=3, pady=10)
        
        self.auth_status = ttk.Label(cred_frame, text="Not authenticated", foreground="red")
        self.auth_status.grid(row=3, column=0, columnspan=3)
        
        # Device Settings Section
        device_frame = ttk.LabelFrame(main_frame, text="Device Settings", padding="10")
        device_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=10)
        
        ttk.Label(device_frame, text="Device Serial:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.device_serial_entry = ttk.Entry(device_frame, width=30)
        self.device_serial_entry.grid(row=0, column=1, sticky=(tk.W, tk.E), pady=5)
        self.device_serial_entry.insert(0, "FG3451360")  # Default value
        
        ttk.Label(device_frame, text="Channel No:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.channel_var = tk.IntVar(value=1)
        self.channel_spinbox = ttk.Spinbox(device_frame, from_=1, to=16, textvariable=self.channel_var, width=10)
        self.channel_spinbox.grid(row=1, column=1, sticky=tk.W, pady=5)
        
        # Stream Settings Section
        stream_frame = ttk.LabelFrame(main_frame, text="Stream Settings", padding="10")
        stream_frame.grid(row=3, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=10)
        
        ttk.Label(stream_frame, text="Protocol:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.protocol_var = tk.StringVar(value="2")
        protocol_combo = ttk.Combobox(stream_frame, textvariable=self.protocol_var, width=20)
        protocol_combo['values'] = ("1 - ezopen", "2 - HLS", "3 - RTMP", "4 - FLV")
        protocol_combo.grid(row=0, column=1, sticky=tk.W, pady=5)
        protocol_combo.current(1)  # Default to HLS
        
        ttk.Label(stream_frame, text="Quality:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.quality_var = tk.StringVar(value="1")
        quality_combo = ttk.Combobox(stream_frame, textvariable=self.quality_var, width=20)
        quality_combo['values'] = ("1 - HD (Main)", "2 - Fluent (Sub)")
        quality_combo.grid(row=1, column=1, sticky=tk.W, pady=5)
        quality_combo.current(0)  # Default to HD
        
        ttk.Label(stream_frame, text="Expire Time (seconds):").grid(row=2, column=0, sticky=tk.W, pady=5)
        self.expire_var = tk.IntVar(value=3600)
        self.expire_spinbox = ttk.Spinbox(stream_frame, from_=30, to=86400, 
                                         textvariable=self.expire_var, width=10, increment=300)
        self.expire_spinbox.grid(row=2, column=1, sticky=tk.W, pady=5)
        
        # Stream Type
        ttk.Label(stream_frame, text="Stream Type:").grid(row=3, column=0, sticky=tk.W, pady=5)
        self.stream_type_var = tk.StringVar(value="live")
        stream_type_combo = ttk.Combobox(stream_frame, textvariable=self.stream_type_var, width=20)
        stream_type_combo['values'] = ("live", "playback")
        stream_type_combo.grid(row=3, column=1, sticky=tk.W, pady=5)
        stream_type_combo.current(0)
        stream_type_combo.bind('<<ComboboxSelected>>', self.on_stream_type_change)
        
        # Playback Time Frame (initially hidden)
        self.playback_frame = ttk.Frame(stream_frame)
        
        ttk.Label(self.playback_frame, text="Start Time:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.start_time_entry = ttk.Entry(self.playback_frame, width=25)
        self.start_time_entry.grid(row=0, column=1, sticky=tk.W, pady=5)
        self.start_time_entry.insert(0, datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        
        ttk.Label(self.playback_frame, text="Stop Time:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.stop_time_entry = ttk.Entry(self.playback_frame, width=25)
        self.stop_time_entry.grid(row=1, column=1, sticky=tk.W, pady=5)
        self.stop_time_entry.insert(0, datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        
        # Generate Button
        self.generate_button = ttk.Button(main_frame, text="Generate Stream URL", 
                                         command=self.generate_url, state='disabled')
        self.generate_button.grid(row=4, column=0, columnspan=2, pady=20)
        
        # Result Section
        result_frame = ttk.LabelFrame(main_frame, text="Result", padding="10")
        result_frame.grid(row=5, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=10)
        
        self.result_text = scrolledtext.ScrolledText(result_frame, height=10, width=80, wrap=tk.WORD)
        self.result_text.grid(row=0, column=0, columnspan=2, pady=5)
        
        button_frame = ttk.Frame(result_frame)
        button_frame.grid(row=1, column=0, columnspan=2, pady=5)
        
        self.copy_button = ttk.Button(button_frame, text="Copy URL", command=self.copy_url, state='disabled')
        self.copy_button.pack(side=tk.LEFT, padx=5)
        
        self.clear_button = ttk.Button(button_frame, text="Clear", command=self.clear_result)
        self.clear_button.pack(side=tk.LEFT, padx=5)
        
        # Add save/load config buttons
        self.save_config_btn = ttk.Button(button_frame, text="Save Config", command=self.save_config)
        self.save_config_btn.pack(side=tk.LEFT, padx=5)
        
        self.load_config_btn = ttk.Button(button_frame, text="Load Config", command=self.load_config)
        self.load_config_btn.pack(side=tk.LEFT, padx=5)
        
        # Setup right-click context menu
        self.setup_context_menu()
    
    def setup_context_menu(self):
        """Setup right-click context menu for entry fields"""
        self.context_menu = tk.Menu(self.root, tearoff=0)
        self.context_menu.add_command(label="Cut", accelerator="Ctrl+X")
        self.context_menu.add_command(label="Copy", accelerator="Ctrl+C")
        self.context_menu.add_command(label="Paste", accelerator="Ctrl+V")
        self.context_menu.add_separator()
        self.context_menu.add_command(label="Select All", accelerator="Ctrl+A")
        
        # Bind to all entry widgets
        for widget in [self.app_key_entry, self.app_secret_entry, self.device_serial_entry,
                      self.start_time_entry, self.stop_time_entry]:
            widget.bind("<Button-3>", lambda e: self.show_context_menu(e))
            # Enable standard keyboard shortcuts
            widget.bind("<Control-a>", lambda e: e.widget.select_range(0, tk.END))
    
    def show_context_menu(self, event):
        """Show context menu at cursor position"""
        # Get the widget that was clicked
        widget = event.widget
        
        # Update menu commands for the specific widget
        self.context_menu.entryconfig(0, command=lambda: widget.event_generate("<<Cut>>"))
        self.context_menu.entryconfig(1, command=lambda: widget.event_generate("<<Copy>>"))
        self.context_menu.entryconfig(2, command=lambda: widget.event_generate("<<Paste>>"))
        self.context_menu.entryconfig(4, command=lambda: widget.select_range(0, tk.END))
        
        # Show the menu
        self.context_menu.post(event.x_root, event.y_root)
    
    def paste_to_entry(self, entry_widget):
        """Paste clipboard content to the specified entry widget"""
        try:
            # Clear current content
            entry_widget.delete(0, tk.END)
            # Get clipboard content
            clipboard_content = self.root.clipboard_get()
            # Insert into entry
            entry_widget.insert(0, clipboard_content.strip())
        except tk.TclError:
            messagebox.showwarning("Paste Error", "No text in clipboard")
    
    def paste_to_focused_entry(self):
        """Paste to currently focused entry widget"""
        focused = self.root.focus_get()
        if isinstance(focused, (ttk.Entry, tk.Entry)):
            focused.event_generate("<<Paste>>")
    
    def toggle_secret_visibility(self):
        """Toggle visibility of the app secret"""
        if self.show_secret_var.get():
            self.app_secret_entry.config(show="*")
            self.toggle_secret_btn.config(text="Show")
            self.show_secret_var.set(False)
        else:
            self.app_secret_entry.config(show="")
            self.toggle_secret_btn.config(text="Hide")
            self.show_secret_var.set(True)
    
    def save_config(self):
        """Save current configuration to a JSON file"""
        try:
            config = {
                "app_key": self.app_key_entry.get(),
                "device_serial": self.device_serial_entry.get(),
                "channel": self.channel_var.get(),
                "protocol": self.protocol_var.get(),
                "quality": self.quality_var.get(),
                "expire_time": self.expire_var.get()
            }
            
            # Ask user if they want to save the secret
            save_secret = messagebox.askyesno("Save Secret?", 
                                            "Do you want to save the App Secret?\n" +
                                            "(Not recommended for security reasons)")
            if save_secret:
                config["app_secret"] = self.app_secret_entry.get()
            
            # Ask where to save
            filename = filedialog.asksaveasfilename(
                defaultextension=".json",
                filetypes=[("JSON files", "*.json"), ("All files", "*.*")],
                initialfile="ezviz_config.json"
            )
            
            if filename:
                with open(filename, "w") as f:
                    json.dump(config, f, indent=2)
                messagebox.showinfo("Success", f"Configuration saved to {os.path.basename(filename)}")
        except Exception as e:
            messagebox.showerror("Save Error", f"Failed to save configuration: {str(e)}")
    
    def load_config(self):
        """Load configuration from a JSON file"""
        try:
            filename = filedialog.askopenfilename(
                filetypes=[("JSON files", "*.json"), ("All files", "*.*")],
                initialfile="ezviz_config.json"
            )
            
            if not filename:
                return
                
            with open(filename, "r") as f:
                config = json.load(f)
            
            # Load values
            if "app_key" in config:
                self.app_key_entry.delete(0, tk.END)
                self.app_key_entry.insert(0, config["app_key"])
            
            if "app_secret" in config:
                self.app_secret_entry.delete(0, tk.END)
                self.app_secret_entry.insert(0, config["app_secret"])
            
            if "device_serial" in config:
                self.device_serial_entry.delete(0, tk.END)
                self.device_serial_entry.insert(0, config["device_serial"])
            
            if "channel" in config:
                self.channel_var.set(config["channel"])
            
            if "protocol" in config:
                self.protocol_var.set(config["protocol"])
            
            if "quality" in config:
                self.quality_var.set(config["quality"])
            
            if "expire_time" in config:
                self.expire_var.set(config["expire_time"])
            
            messagebox.showinfo("Success", "Configuration loaded successfully")
        except FileNotFoundError:
            messagebox.showwarning("Load Error", "Configuration file not found")
        except Exception as e:
            messagebox.showerror("Load Error", f"Failed to load configuration: {str(e)}")
    
    def on_stream_type_change(self, event=None):
        if self.stream_type_var.get() == "playback":
            self.playback_frame.grid(row=4, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        else:
            self.playback_frame.grid_forget()
    
    def authenticate(self):
        app_key = self.app_key_entry.get().strip()
        app_secret = self.app_secret_entry.get().strip()
        
        if not app_key or not app_secret:
            messagebox.showerror("Error", "Please enter both App Key and App Secret")
            return
        
        # Disable button during authentication
        self.auth_button.config(state='disabled')
        self.auth_status.config(text="Authenticating...", foreground="orange")
        
        # Run authentication in a separate thread
        thread = threading.Thread(target=self._authenticate_thread, args=(app_key, app_secret))
        thread.start()
    
    def _authenticate_thread(self, app_key, app_secret):
        try:
            url = "https://open.ezvizlife.com/api/lapp/token/get"
            headers = {"Content-Type": "application/x-www-form-urlencoded"}
            data = {
                "appKey": app_key,
                "appSecret": app_secret
            }
            
            response = requests.post(url, headers=headers, data=data, timeout=10)
            result = response.json()
            
            if result.get("code") == "200":
                self.access_token = result["data"]["accessToken"]
                self.area_domain = result["data"]["areaDomain"]
                self.token_expire_time = result["data"]["expireTime"]
                
                self.root.after(0, self._update_auth_success)
            else:
                error_msg = result.get("msg", "Authentication failed")
                self.root.after(0, self._update_auth_error, error_msg)
                
        except Exception as e:
            self.root.after(0, self._update_auth_error, str(e))
    
    def _update_auth_success(self):
        self.auth_status.config(text="Authenticated successfully!", foreground="green")
        self.auth_button.config(state='normal')
        self.generate_button.config(state='normal')
        messagebox.showinfo("Success", f"Authentication successful!\nArea Domain: {self.area_domain}")
    
    def _update_auth_error(self, error_msg):
        self.auth_status.config(text="Authentication failed", foreground="red")
        self.auth_button.config(state='normal')
        messagebox.showerror("Authentication Error", f"Failed to authenticate: {error_msg}")
    
    def generate_url(self):
        if not self.access_token or not self.area_domain:
            messagebox.showerror("Error", "Please authenticate first")
            return
        
        device_serial = self.device_serial_entry.get().strip()
        if not device_serial:
            messagebox.showerror("Error", "Please enter device serial number")
            return
        
        self.generate_button.config(state='disabled')
        self.result_text.delete(1.0, tk.END)
        self.result_text.insert(tk.END, "Generating stream URL...")
        
        # Run URL generation in a separate thread
        thread = threading.Thread(target=self._generate_url_thread)
        thread.start()
    
    def _generate_url_thread(self):
        try:
            device_serial = self.device_serial_entry.get().strip()
            channel_no = self.channel_var.get()
            protocol = self.protocol_var.get().split(" ")[0]
            quality = self.quality_var.get().split(" ")[0]
            expire_time = self.expire_var.get()
            
            url = f"{self.area_domain}/api/lapp/live/address/get"
            headers = {"Content-Type": "application/x-www-form-urlencoded"}
            
            data = {
                "accessToken": self.access_token,
                "deviceSerial": device_serial,
                "channelNo": channel_no,
                "protocol": protocol,
                "quality": quality,
                "expireTime": expire_time
            }
            
            # Add type and time parameters for playback
            if self.stream_type_var.get() == "playback":
                data["type"] = "2"  # Local recording playback
                data["startTime"] = self.start_time_entry.get()
                data["stopTime"] = self.stop_time_entry.get()
            
            response = requests.post(url, headers=headers, data=data, timeout=10)
            result = response.json()
            
            self.root.after(0, self._update_result, result)
            
        except Exception as e:
            self.root.after(0, self._update_error, str(e))
    
    def _update_result(self, result):
        self.result_text.delete(1.0, tk.END)
        
        if result.get("code") == "200":
            data = result.get("data", {})
            stream_url = data.get("url", "No URL in response")
            expire_time = data.get("expireTime", "Unknown")
            stream_id = data.get("id", "Unknown")
            
            result_text = f"Stream URL Generated Successfully!\n\n"
            result_text += f"URL: {stream_url}\n\n"
            result_text += f"Stream ID: {stream_id}\n"
            result_text += f"Expires at: {expire_time}\n\n"
            result_text += "=" * 50 + "\n"
            result_text += f"Full Response:\n{json.dumps(result, indent=2)}"
            
            self.result_text.insert(tk.END, result_text)
            self.copy_button.config(state='normal')
            
            # Highlight the URL
            start_idx = self.result_text.search("URL:", "1.0")
            if start_idx:
                end_idx = self.result_text.search("\n", f"{start_idx}+5c")
                self.result_text.tag_add("url", f"{start_idx}+5c", end_idx)
                self.result_text.tag_config("url", foreground="blue", underline=True)
        else:
            error_msg = result.get("msg", "Unknown error")
            error_code = result.get("code", "Unknown")
            self.result_text.insert(tk.END, f"Error {error_code}: {error_msg}\n\n")
            self.result_text.insert(tk.END, f"Full Response:\n{json.dumps(result, indent=2)}")
            self.copy_button.config(state='disabled')
        
        self.generate_button.config(state='normal')
    
    def _update_error(self, error_msg):
        self.result_text.delete(1.0, tk.END)
        self.result_text.insert(tk.END, f"Error: {error_msg}")
        self.generate_button.config(state='normal')
        self.copy_button.config(state='disabled')
    
    def copy_url(self):
        # Extract just the URL from the result text
        text = self.result_text.get(1.0, tk.END)
        for line in text.split('\n'):
            if line.startswith("URL:"):
                url = line.replace("URL:", "").strip()
                pyperclip.copy(url)
                messagebox.showinfo("Success", "URL copied to clipboard!")
                break
    
    def clear_result(self):
        self.result_text.delete(1.0, tk.END)
        self.copy_button.config(state='disabled')

def main():
    root = tk.Tk()
    app = EzvizStreamGUI(root)
    
    # Center the window on screen
    root.update_idletasks()
    width = root.winfo_width()
    height = root.winfo_height()
    # x = (root.winfo_screenwidth() // 2) - (width // 2)
    # y = (root.winfo_screenheight() // 2) - (height // 2)
    # root.geometry(f"{width}x{height}+{x}+{y}")
    
    root.mainloop()

if __name__ == "__main__":
    main()