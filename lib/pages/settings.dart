import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSessionTimerOn=false;
  bool isAutoLogoutOn=false;
  bool isNotifiationOn=true;

  @override
  Widget build(BuildContext context) { 

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Notifications",style: TextStyle(fontSize: 20, color: Colors.white ),),
                SizedBox(
                  width: 30*1.7,
                  height: 20*1.7,
                  
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(value: isNotifiationOn, onChanged: (bool newValue,){
                      setState(() {
                        isNotifiationOn=newValue;
                      });
                    },activeColor: primary,
                    ),
                  ),
                )
        
              ],
            ),            
            Text(
              "Enable: allows push notification remainders for next service and refueling",
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5),fontStyle: FontStyle.italic)
            ),
        
              
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Session timer",style: TextStyle(fontSize: 20, color: Colors.white ),),
                SizedBox(
                  width: 30*1.7,
                  height: 20*1.7,
                  
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(value: isSessionTimerOn, onChanged: (bool newValue,){
                      setState(() {
                        isSessionTimerOn=newValue;
                      });
                    },activeColor: primary,
                    ),
                  ),
                )
        
              ],
            ),
            Text(
              "Enable: automatically logout after 10 minutes of inactivity",
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5),fontStyle: FontStyle.italic)
            ),
        
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Auto Logout",style: TextStyle(fontSize: 20, color: Colors.white ),),
                SizedBox(
                  width: 30*1.7,
                  height: 20*1.7,
                  
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(value: isAutoLogoutOn, onChanged: (bool newValue,){
                      setState(() {
                        isAutoLogoutOn=newValue;
                      });
                    },activeColor: primary,
                    ),
                  ),
                )
        
              ],
            ),
            Text(
              "Enable: automatically logsout upon closing the app",
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5),fontStyle: FontStyle.italic)
            ),
            
          ],
        ),
      ),
    );
  }
}