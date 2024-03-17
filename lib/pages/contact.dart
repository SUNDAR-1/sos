import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appbar.dart';
import 'globals.dart';

class Note extends StatefulWidget {
  const Note({Key? key});

  @override
  State<Note> createState() => _NoteState();
  

  // Define a static method to get the contacts list
  
}

class _NoteState extends State<Note> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

   final List<Contact> _contacts =[];
   


  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? contactsData = prefs.getStringList('contacts');
    if (contactsData != null) {
      setState(() {
        _contacts.clear();
        for (final contactData in contactsData) {
          final contactFields = contactData.split('|'); 
          if (contactFields.length == 2) {
            _contacts.add(Contact(name: contactFields[0], phone: contactFields[1]));
          }
        }
      });
        globalContacts = _contacts;
    }
  }

  Future<void> saveContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> contactsData = _contacts.map((contact) => '${contact.name}|${contact.phone}').toList();
    await prefs.setStringList('contacts', contactsData);
  }

  void _addContact() {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    if (name.isNotEmpty && isMobileNumberValid(phone)) {
      setState(() {
        _contacts.add(Contact(name: name, phone: phone));
        _nameController.clear();
        _phoneController.clear();
        saveContacts(); // Save the updated contacts
      });
      globalContacts = _contacts;
      Navigator.of(context).pop(); // Close the dialog
    } else {
      String errorMsg = 'Please enter a valid phone number with at least 10 digits.';
      if (name.isEmpty) {
        errorMsg = 'Please fill in the name and $errorMsg';
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text(errorMsg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool isMobileNumberValid(String phoneNumber) {
    // Regular expression to check if the phone number contains at least 10 digits
    final RegExp regex = RegExp(r'^[0-9]{10,}$');
    return regex.hasMatch(phoneNumber);
  }

  void _editContact(int index) {
    final contact = _contacts[index];
    setState(() {
      _nameController.text = contact.name;
      _phoneController.text = contact.phone;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone No'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _nameController.clear();
                  _phoneController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isMobileNumberValid(_phoneController.text)) {
                  _contacts[index] = Contact(name: _nameController.text, phone: _phoneController.text);
                  saveContacts();
                  setState(() {
                    _nameController.clear();
                    _phoneController.clear();
                  });
                  Navigator.of(context).pop();
                } else {
                  String errorMsg = 'Please enter a valid phone number with at least 10 digits.';
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Invalid Input'),
                        content: Text(errorMsg),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editContact(index); // Open the edit dialog
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _contacts.removeAt(index);
                      saveContacts(); // Save the updated contacts
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _nameController.clear();
            _phoneController.clear();
          });
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Contact'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone No'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addContact();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});
}

