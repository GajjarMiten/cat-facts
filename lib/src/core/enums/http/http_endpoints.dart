enum Endpoints {
  allFacts("facts"),
  fact("fact"),

  // !default
  unknown('unknown');


  final String url;
  const Endpoints(this.url);
}
