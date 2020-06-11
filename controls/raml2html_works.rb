title 'Tests to confirm raml2html binary works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "raml2html")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-raml2html' do
  impact 1.0
  title 'Ensure raml2html binary is working as expected'
  desc '
  We first check that the raml2html binary we expect is present and then run version checks on both to verify that it is excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  raml2html_exists = command("ls #{File.join(target_dir, "raml2html")}")
  describe raml2html_exists do
    its('stdout') { should match /raml2html/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  raml2html_works = command("/bin/raml2html --version")
  describe raml2html_works do
    its('stdout') { should match /[0-9]+.[0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end
end
