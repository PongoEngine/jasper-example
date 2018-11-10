let project = new Project('jasper-example');

project.addLibrary("jasper");
project.addSources('Sources');
// project.addParameter('--connect 6000');
// project.addParameter('-debug');
project.addAssets('Assets/**');

resolve(project);