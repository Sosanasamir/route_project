import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String selectedAvatar = 'assets/images/avatar1.png';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<String> avatarList = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png',
    'assets/images/avatar9.png',
  ];

  @override
  void initState() {
    super.initState();

    final state = context.read<ProfileCubit>().state;
    if (state is ProfileSuccess) {
      nameController.text = state.user.displayName ?? "";

      selectedAvatar =
          (state.user.photoURL != null && state.user.photoURL!.isNotEmpty)
          ? state.user.photoURL!
          : 'assets/images/avatar1.png';
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282A28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: avatarList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() => selectedAvatar = avatarList[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedAvatar == avatarList[index]
                          ? const Color(0xFFF6BD00)
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(avatarList[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF282A28),
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure? This will permanently delete your movie history and watchlist.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileCubit>().deleteAccount();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Color(0xFFE82626)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDeleted) {
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        } else if (state is ProfileResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reset email sent! Check your inbox."),
              backgroundColor: Colors.blue,
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is ProfileSuccess && Navigator.canPop(context)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile Updated!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ProfileLoading;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFF121312),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Update Profile",
                  style: TextStyle(color: Color(0xFFF6BD00)),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFF6BD00)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildAvatarSection(isLoading),
                          const SizedBox(height: 40),
                          _buildTextField(
                            nameController,
                            Icons.person,
                            "Name",
                            isLoading,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            phoneController,
                            Icons.phone,
                            "Phone Number",
                            isLoading,
                            keyboardType: TextInputType.phone,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pushNamed(
                                      context,
                                      'forget_password_view',
                                    ),
                              child: const Text(
                                "Reset Password?",
                                style: TextStyle(
                                  color: Color(0xFFF6BD00),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFullWidthButton(
                          "Delete Account",
                          const Color(0xFFE82626).withOpacity(0.1),
                          const Color(0xFFE82626),
                          isLoading ? null : _confirmDelete,
                          isBordered: true,
                        ),
                        const SizedBox(height: 15),
                        _buildFullWidthButton(
                          "Update Data",
                          const Color(0xFFF6BD00),
                          Colors.black,
                          isLoading
                              ? null
                              : () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    context.read<ProfileCubit>().updateUserData(
                                      nameController.text.trim(),
                                      selectedAvatar,
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF6BD00)),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarSection(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _showAvatarPicker,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[900],
            backgroundImage: AssetImage(selectedAvatar),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Color(0xFFF6BD00),
              radius: 18,
              child: Icon(Icons.edit, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hint,
    bool disabled, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: !disabled,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF282A28),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
    String text,
    Color bg,
    Color textCol,
    VoidCallback? tap, {
    bool isBordered = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          side: isBordered ? BorderSide(color: textCol, width: 1) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textCol,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
