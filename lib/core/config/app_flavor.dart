/// Build / distribution environment for Shishur Dinlipi.
enum AppFlavor {
  dev,
  staging,
  prod;

  bool get isDev => this == AppFlavor.dev;
  bool get isStaging => this == AppFlavor.staging;
  bool get isProd => this == AppFlavor.prod;
}
