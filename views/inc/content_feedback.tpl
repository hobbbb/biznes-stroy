<form method="post" action="/content_feedback/">
<input type="hidden" name="referer" value="[% request.referer %]">
    <fieldset class="form">
        <legend>Введите</legend>
        <p><input type="text" name="phone" placeholder="Телефон" value="" style="width: 250px" /> <span class="Requirement">*</span></p>
        <p><input type="text" name="email" placeholder="E-mail" value="" style="width: 250px"/></p>
        <p><input type="text" name="name" placeholder="Название компании или имя" value="" style="width: 250px" /></p>
        <p><textarea name="about" placeholder="О компании" style="width: 250px" /></textarea></p>
    </fieldset>
    <input type="submit" value="Отправить">
</form>
