import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/builder_repository.dart';

// Profile Data Provider
final builderProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(builderRepositoryProvider);
  return repository.getBuilderProfile();
});

// Portfolio Stream Provider
final builderPortfolioProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(builderRepositoryProvider);
  return repository.getPortfolioStream();
});

// Controller Provider
final builderControllerProvider = StateNotifierProvider<BuilderController, AsyncValue<void>>((ref) {
  return BuilderController(ref.watch(builderRepositoryProvider), ref);
});

class BuilderController extends StateNotifier<AsyncValue<void>> {
  final BuilderRepository _repository;
  final Ref _ref;

  BuilderController(this._repository, this._ref) : super(const AsyncValue.data(null));

  // Update Profile
  Future<void> updateProfile({
    required String bio,
    required String yearsExperience,
    required String serviceArea,
    required String youtube,
    required String instagram,
    Map<String, dynamic>? pricing,
    Map<String, dynamic>? availability,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = {
        'bio': bio,
        'yearsExperience': yearsExperience,
        'serviceArea': serviceArea,
        'socialLinks': {
          'youtube': youtube,
          'instagram': instagram,
        },
        if (pricing != null) 'pricing': pricing,
        if (availability != null) 'availability': availability,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _repository.updateBuilderProfile(data);
      _ref.invalidate(builderProfileProvider);
    });
  }

  // Updated: Handles Image Upload automatically
  Future<void> addPortfolioItem({
    required String name,
    required String description,
    required String cost,
    required String imageUrl, // Can be local path or network URL
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      String finalImageUrl = imageUrl;

      // Check if it's a local file (not http) and not empty
      if (!imageUrl.startsWith('http') && imageUrl.isNotEmpty) {
        final file = File(imageUrl);
        if (await file.exists()) {
          // Upload to Storage (folder: 'portfolio')
          // Using the repository method we just added
          finalImageUrl = await _repository.uploadImage(file, 'portfolio');
        }
      }

      await _repository.addPortfolioItem(
        name: name,
        description: description,
        cost: cost,
        imageUrl: finalImageUrl,
      );
    });
  }

  // Delete Portfolio Item
  Future<void> deletePortfolioItem(String itemId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deletePortfolioItem(itemId);
    });
  }
}