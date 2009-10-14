require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe InstallTheme::Parsers::RailsForm do
  describe "introspect a rails form" do
    context "simple rails html form modified from http://github.com/inbox/new" do
      before(:each) do
        html = <<-HTML
        <h1>Compose message</h1>
        <form method="post" id="new_message" class="new_message" action="/messages">
          <div class="buttons buttons-top">
            <input type="submit" value="Send" name="commit" id="message_submit" class="send"/>
            <a class="cancel" href="#">Cancel</a>
          </div>
          <div class="field">
            <label for="message_to">To:</label>
            <input type="text" value="" size="30" name="message[to]" id="message_to" class="autocompleter ac_input" autocomplete="off"/>
          </div>
          <div class="field">
            <label for="message_subject">Subject:</label>
            <input type="text" size="30" name="message[subject]" id="message_subject"/>
          </div>
          <textarea rows="20" name="message[body]" id="message_body" cols="40"/>
          <div class="submits">
            <div class="buttons buttons-bottom">
              <input type="submit" value="Send" name="commit" id="message_submit" class="send"/>
              <a class="cancel" href="#">Cancel</a>
            </div>
          </div>
        </form>
        HTML
        @forms = InstallTheme::Parsers::RailsForm.parse(html)
        @form = @forms.first
      end
      it { @forms.size.should == 1 }
      it { @form.should be_valid }
      it { @form.should be_valid }
      it { @form.inputs.size.should == 3 }
      it { @form.inputs[0].field.should == :to }
      it { @form.inputs[1].field.should == :subject }
      it { @form.inputs[2].field.should == :body }
      it { @form.inputs[0].helper.should == "text_field" }
      it { @form.inputs[1].helper.should == "text_field" }
      it { @form.inputs[2].helper.should == "text_area" }
      it { @form.inputs[0].value.should == "" }
      it { @form.inputs[1].value.should == nil }
      it { @form.inputs[2].value.should == nil }
      it { @form.inputs[0].render.should == "<%= f.text_field :to, :value => '', :class => 'autocompleter ac_input', :size => '30', :autocomplete => 'off' %>" }
      it { @form.inputs[1].render.should == "<%= f.text_field :message, :size => '30' %>" }
      it { @form.inputs[2].render.should == "<%= f.text_area :body, :cols => '40', :rows => '20' %>" }
    end
  end
end