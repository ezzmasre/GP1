import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode
import 'package:http/http.dart' as http;

class coutchpage extends StatefulWidget {
  const coutchpage({super.key});

  @override
  State<coutchpage> createState() => _UserPageState();
}

class _UserPageState extends State<coutchpage> {
  List<dynamic> users = []; // To store the fetched user data
  bool isLoading = true; // To show a loading indicator while fetching data

  // Fetch user data from the server
  Future<void> fetchUsers() async {
    final url = Uri.parse('https://fitnes-bakeend.onrender.com/pro_users/coutch');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          users = data; // Save fetched data to the state
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Stop loading in case of error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to fetch users: ${response.statusCode}',
              style: TextStyle(color: const Color(0xffD5FF5F)),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Error fetching data. Please try again.',
            style: TextStyle(color: Color(0xffD5FF5F)),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // Method to show detailed information of a user
  void showUserDetails(dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            user['name'],
            style: TextStyle(color: const Color(0xffD5FF5F)),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Email: ${user['email']}',
                style: TextStyle(color: const Color(0xffD5FF5F).withOpacity(0.8)),
              ),
              Text(
                'Age: ${user['age']}',
                style: TextStyle(color: const Color(0xffD5FF5F).withOpacity(0.8)),
              ),
              Text(
                'Weight: ${user['weight']} kg',
                style: TextStyle(color: const Color(0xffD5FF5F).withOpacity(0.8)),
              ),
              Text(
                'Role: ${user['role']}',
                style: TextStyle(color: const Color(0xffD5FF5F).withOpacity(0.8)),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xffD5FF5F)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete a user
  Future<void> deleteUser(dynamic user) async {
    final url = Uri.parse(
        'https://fitnes-bakeend.onrender.com/pro_users/${user['email']}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          users.remove(user); // Remove the deleted user from the list
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'User deleted successfully.',
              style: TextStyle(color: Color(0xffD5FF5F)),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete user: ${response.statusCode}',
              style: TextStyle(color: const Color(0xffD5FF5F)),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error deleting user. Please try again.',
            style: TextStyle(color: Color(0xffD5FF5F)),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // Method to update user role
  Future<void> updateUserRole(dynamic user, String newRole) async {
    final url = Uri.parse(
        'https://fitnes-bakeend.onrender.com/pro_users/update_role/${user['email']}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'role': newRole}),
      );

      if (response.statusCode == 200) {
        setState(() {
          user['role'] = newRole; // Update the role locally
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'User role updated successfully.',
              style: TextStyle(color: Color(0xffD5FF5F)),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update role: ${response.statusCode}',
              style: TextStyle(color: const Color(0xffD5FF5F)),
            ),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error updating role. Please try again.',
            style: TextStyle(color: Color(0xffD5FF5F)),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // Method to show dialog for editing role
  void showRoleSelectionDialog(dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Change Role',
            style: TextStyle(color: Color(0xffD5FF5F)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateUserRole(user, 'doctor');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Set as Doctor',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  updateUserRole(user, 'user');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Set as User',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xffD5FF5F)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch user data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(
            color: Color(0xffD5FF5F),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xffD5FF5F)),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD5FF5F)),
              ),
            )
          : users.isEmpty
              ? Center(
                  child: Text(
                    'No users found.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffD5FF5F).withOpacity(0.8),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                      onTap: () {
                        showUserDetails(user); // Show user details on tap
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 8,
                        color: const Color(0xff3C3C3C), // Card color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: const Color(0xffD5FF5F).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 40,
                                    color: const Color(0xffD5FF5F),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Name: ${user['name']}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffD5FF5F),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Email: ${user['email']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xffD5FF5F).withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Role: ${user['role']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xffD5FF5F).withOpacity(0.8),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      showRoleSelectionDialog(user);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Change Role',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.black,
                                            title: const Text(
                                              'Confirm Delete',
                                              style: TextStyle(color: Color(0xffD5FF5F)),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this user?',
                                              style: TextStyle(color: Color(0xffD5FF5F)),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(color: Color(0xffD5FF5F)),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteUser(user);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}