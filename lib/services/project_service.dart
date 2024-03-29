import 'dart:convert';
import 'dart:math';
import 'package:hgeology_app/models/hole.dart';
import 'package:http/http.dart' as http;
import 'package:hgeology_app/models/project.dart';

abstract class ProjectService {
  Future<List<Project>> fetchProjects();
  Future<Project> fetchProjectById(String id);
  Future<List<Hole>> fetchHolesByProjectId(String id);
}

class MockProjectService implements ProjectService {
  @override
  Future<List<Project>> fetchProjects() async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(20, (index) => Project.mock());
  }

  @override
  Future<Project> fetchProjectById(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    return Project.mock().copyWith(id: id);
  }

  @override
  Future<List<Hole>> fetchHolesByProjectId(String projectId) async {
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock holes data
    // Assuming each project could have a random number of holes up to 10
    int numberOfHoles = Random().nextInt(10) + 1;
    List<Hole> holes = List.generate(
        numberOfHoles, (index) => Hole.mock().copyWith(projectId: projectId));

    return holes;
  }
}

class RealProjectService implements ProjectService {
  @override
  Future<List<Hole>> fetchHolesByProjectId(String projectId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Generate mock holes data
    // Assuming each project could have a random number of holes up to 10
    int numberOfHoles = Random().nextInt(10) + 1;
    List<Hole> holes = List.generate(
        numberOfHoles, (index) => Hole.mock().copyWith(projectId: projectId));

    return holes;
  }

  @override
  Future<Project> fetchProjectById(String id) async {
    // TODO Replace with real logic
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Return a mock project with the given ID
    // For simplicity, we're just returning a new mock project
    // In a real scenario, you would fetch from your data store based on the ID
    return Project.mock().copyWith(id: id);
  }

  @override
  Future<List<Project>> fetchProjects() async {
    const baseUrl =
        'http://124.220.91.25:1500/api/pub/ProjectInfo/GetProjectInfoList';
    final queryParams = {
      'keyWord': '',
      'projectName': '',
      'projectNameing': '',
      'projectCategory': '',
      'projectState': '',
      'explorationPhase': '',
      'startDate': '',
      'projectManagerID': '',
      'pageSize': '20',
      'pageIdx': '1',
      'inCludeDel': 'false',
      'inCludeDisabled': 'false',
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2YTZmMmFhZTdmYmQ0YjgzODAyNGRlYWI2NjY0ODVjNyIsImlhdCI6IjE2OTk1OTU5OTk5NzgiLCJleHAiOjE2OTk2ODIzOTksImlzcyI6IkFQSS5DRU0iLCJhdWQiOiIxIiwiZ2l2ZW5fbmFtZSI6ImFkbWluIiwiYXV0aF90aW1lIjoiMTQ0MCIsIm5hbWUiOiJiYXNpYyJ9.XcqSNRK0o-CdEVs6m0PJ9ysxn1vbqQwykdIefsKRVxE', // Replace with your actual token
        'content-type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return List<Project>.from(data['data'].map((x) => Project.fromJson(x)));
    } else {
      // Handle the case where the server returns an error
      throw Exception('Failed to load projects');
    }
  }
}
