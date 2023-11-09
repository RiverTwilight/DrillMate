enum FeatureFlags { cloudSync, dailyReview, themeColor, unlimitMedia }

const plusFeatures = [
  FeatureFlags.cloudSync,
  FeatureFlags.dailyReview,
  FeatureFlags.themeColor
];

bool hasPrivilage(FeatureFlags feature, bool isPlusSubscriber) {
  return ((plusFeatures.contains(feature) && isPlusSubscriber) ||
      !plusFeatures.contains(feature));
}
