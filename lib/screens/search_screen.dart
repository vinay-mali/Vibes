import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/user_model.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_avatar.dart';
import 'package:vibes/widgets/app_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCtrl = TextEditingController();
  bool _isSearching = false;
  bool _isLoadingRandomUser = false;
  List<UserModel> _randomUsers = [];
  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    handleRandomUser();
  }

  Future<void> handleSearch() async {
    if (searchCtrl.text.trim().toLowerCase().isEmpty) {
      scaffoldMessage(context, "Please write something to search");
      return;
    }
    setState(() {
      _isLoading = true;
      _isSearching = true;
      FocusScope.of(context).unfocus();
    });
    try {
      _searchResults = await context.read<UserProvider>().searchUser(
        searchCtrl.text.trim().toLowerCase(),
      );
    } catch (e) {
      scaffoldMessage(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleRandomUser() async {
    setState(() {
      _isLoadingRandomUser = true;
    });
    try {
      final users = await context.read<UserProvider>().fetchRandomUser();
      setState(() {
        _randomUsers = users;
      });
    } catch (e) {
      scaffoldMessage(context, e.toString());
    } finally {
      setState(() {
        _isLoadingRandomUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Explore"),
        backgroundColor: Colors.transparent,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E8FF), Color(0xFFEDE9FE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    suffixIcon: _isSearching
                        ? IconButton(
                            onPressed: () {
                              searchCtrl.clear();
                              setState(() {
                                _searchResults = [];
                                _isSearching = false;
                              });
                            },
                            icon: Icon(Icons.close),
                          )
                        : IconButton(
                            onPressed: handleSearch,
                            icon: Icon(Icons.search),
                          ),
                    hintText: "Search",
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              if (_isSearching)
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : _searchResults.isEmpty
                      ? Center(child: AppText(text: "No users found"))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                await context.read<UserProvider>().getUserByID(
                                  _searchResults[index].uid,
                                );
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileVisitScreen(mode: 'other'),
                                  ),
                                );
                              },
                              leading: AppAvatar(
                                photoUrl: _searchResults[index].photoUrl,
                              ),
                              title: AppText(
                                text: _searchResults[index].fullName,
                              ),
                              subtitle: AppText(
                                text: "@${_searchResults[index].username}",
                                textColor: Colors.grey,
                                textFontSize: 14,
                              ),
                            );
                          },
                        ),
                ),
              if (!_isSearching) SizedBox(height: 20),
              if (!_isSearching)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: AppText(text: "Suggestions"),
                  ),
                ),
              if (!_isSearching)
                Expanded(
                  child: _isLoadingRandomUser
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : GridView.builder(
                          itemCount: _randomUsers.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                              ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  //border: Border.all(width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      color: Colors.purple.shade400,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await context
                                            .read<UserProvider>()
                                            .getUserByID(
                                              _randomUsers[index].uid,
                                            );
                                        if (!mounted) return;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileVisitScreen(
                                                  mode: 'other',
                                                ),
                                          ),
                                        );
                                      },
                                      child: AppAvatar(
                                        radius: 50,
                                        photoUrl: _randomUsers[index].photoUrl,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _randomUsers[index].fullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _randomUsers[index].username,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
