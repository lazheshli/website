defmodule LzhWeb.ContentComponents do
  @moduledoc """
  Non-generic UI components with hard-coded content.

  At some point in the future the content should come from the database and the
  components migrated to the LzhWeb.Components module.
  """
  use Phoenix.Component

  def election_details(%{year: 2024, month: "октомври"} = assigns) do
    ~H"""
    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверяваме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на осмото издание на <b>„Лъжеш ли?“</b>
        проверяваме истиността на изказванията на следните кандидати за Народно събрание, които ще участват в изборите на 27.10.2024:
      </p>

      <h3 class="pb-2 text-lg font-bold">ГЕРБ-СДС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Делян Добрев</li>
        <li>Йорданка Фандъкова</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Продължаваме промяната – Демократична България</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Асен Василев</li>
        <li>Кирил Петков</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">ДПС - Ново начало</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Йордан Цонев</li>
        <li>Калин Стоянов</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Алианс за права и свободи - АПС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Джевдет Чакъров</li>
        <li>Николай Цонев</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Възраждане</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Костадин Костадинов</li>
        <li>Цончо Ганев</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">БСП - Обединена левица</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Атанас Зафиров</li>
        <li>Борислав Гуцанов</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Има такъв народ</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Станислав Балабанов</li>
        <li>Тошко Хаджитодоров</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Величие</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Ивелин Михайлов</li>
        <li>Красимира Катиничарова</li>
      </ul>
    </details>

    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледаме?
      </summary>

      <p class="pb-4 text-lg">
        Обхватът на осмото издание на <b>„Лъжеш ли?“</b>
        са предизборните дебати и интервюта в национален ефир. Това включва всички предизборни дебати и интервюта по <b>БНТ</b>,
        <b>bTV</b>
        и <b>NOVA</b>.
      </p>
    </details>

    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кога ще обявим резултатите от проверката?
      </summary>

      <p class="pb-4 text-lg">
        Резултатите от проверката на изказванията на избраните кандидати за Народно събрание и Европейски парламент ще публикуваме на <b>26.10.2024</b>.
        За акценти от предизборната кампания следете страниците ни във <a
          href="https://www.facebook.com/lazheshli"
          title="Последвай ни във Facebook"
          class="underline"
        >Facebook</a>, <a
          href="https://www.instagram.com/lazheshli/"
          title="Последвай ни в Instagram"
          class="underline"
          phx-no-format
        >Instagram</a> и <a
          href="https://www.threads.net/@lazheshli"
          title="Последвай ни в Threads"
          class="underline"
        >Threads</a>.
      </p>
    </details>
    """
  end

  def election_details(%{year: 2024, month: "юни", show_statements: true} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на седмото издание на <b>„Лъжеш ли?“</b>
        проверихме истиността на изказванията на следните кандидати за Народно събрание и Европейски парламент на изборите на 09.06.2024:
      </p>

      <h3 class="pb-2 text-lg font-bold">ГЕРБ-СДС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Бойко Борисов</li>
        <li>Делян Добрев</li>
        <li>Росен Желязков</li>
        <li>Деница Сачева</li>
        <li>Даниел Митов</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Продължаваме промяната – Демократична България</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Кирил Петков</li>
        <li>Асен Василев</li>
        <li>Даниел Лорер</li>
        <li>Стефан Тафров</li>
        <li>Христо Иванов</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">ДПС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Делян Пеевски</li>
        <li>Джевдет Чакъров</li>
        <li>Йордан Цонев</li>
        <li>Илхан Кючюк</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Възраждане</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Костадин Костадинов</li>
        <li>Цончо Ганев</li>
        <li>Петър Волгин</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">БСП за България</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Корнелия Нинова</li>
        <li>Георги Свиленски</li>
        <li>Кристиан Вигенин</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Има такъв народ</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Станислав Трифонов</li>
        <li>Тошко Хаджитодоров</li>
        <li>Ивайло Вълчев</li>
        <li>Станислав Балабанов</li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Обхватът на седмото издание на <b>„Лъжеш ли?“</b>
        са предизборните дебати и интервюта в национален ефир, които се проведоха в периода от
        <b>10.05.2024</b>
        до <b>07.06.2024</b>. Това включва всички предизборни дебати и интервюта по <b>БНТ</b>,
        <b>bTV</b>
        и <b>NOVA</b>.
      </p>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кой имаше най-много ефирно време?
      </summary>

      <p class="pb-4 text-lg">
        Шестте партии и коалиции на 24-мата кандидати в нашата извадка имаха следното ефирно време в рамките на предизборната кампания:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>Възраждане</b> &mdash; 302 минути</li>
        <li><b>БСП за България</b> &mdash; 182 минути</li>
        <li><b>Има такъв народ</b> &mdash; 163 минути</li>
        <li><b>ГЕРБ-СДС</b> &mdash; 153 минути</li>
        <li><b>Продължаваме промяната – Демократична България</b> &mdash; 145 минути</li>
        <li><b>ДПС</b> &mdash; 9 минути</li>
      </ul>
    </details>
    """
  end

  def election_details(%{year: 2024, month: "юни"} = assigns) do
    ~H"""
    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверяваме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на седмото издание на <b>„Лъжеш ли?“</b>
        проверяваме истиността на изказванията на следните кандидати за Народно събрание и Европейски парламент, които ще участват в изборите на 09.06.2024:
      </p>

      <h3 class="pb-2 text-lg font-bold">ГЕРБ-СДС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Бойко Борисов</li>
        <li>Делян Добрев</li>
        <li>Росен Желязков</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Продължаваме промяната – Демократична България</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Кирил Петков</li>
        <li>Асен Василев</li>
        <li>Даниел Лорер</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">ДПС</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Делян Пеевски</li>
        <li>Джевдет Чакъров</li>
        <li>Йордан Цонев</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Възраждане</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Костадин Костадинов</li>
        <li>Цончо Ганев</li>
        <li>Петър Волгин</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">БСП</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Корнелия Нинова</li>
        <li>Георги Свиленски</li>
        <li>Кристиан Вигенин</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Има такъв народ</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Станислав Трифонов</li>
        <li>Тошко Хаджитодоров</li>
        <li>Ивайло Вълчев</li>
      </ul>
    </details>

    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледаме?
      </summary>

      <p class="pb-4 text-lg">
        Обхватът на седмото издание на <b>„Лъжеш ли?“</b>
        са предизборните дебати и интервюта в национален ефир, които ще се проведат в периода от
        <b>10.05.2024</b>
        до <b>07.06.2024</b>. Това включва всички предизборни дебати и интервюта по <b>БНТ</b>,
        <b>bTV</b>
        и <b>NOVA</b>.
      </p>
    </details>

    <details class="mb-6" open>
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кога ще обявим резултатите от проверката?
      </summary>

      <p class="pb-4 text-lg">
        Резултатите от проверката на изказванията на избраните кандидати за Народно събрание и Европейски парламент ще публикуваме на <b>08.06.2024</b>.
        За акценти от предизборната кампания следете страниците ни във <a
          href="https://www.facebook.com/lazheshli"
          title="Последвай ни във Facebook"
          class="underline"
        >Facebook</a>, <a
          href="https://www.instagram.com/lazheshli/"
          title="Последвай ни в Instagram"
          class="underline"
          phx-no-format
        >Instagram</a> и <a
          href="https://www.threads.net/@lazheshli"
          title="Последвай ни в Threads"
          class="underline"
        >Threads</a>.
      </p>
    </details>
    """
  end

  def election_details(%{year: 2023, month: "октомври"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на настоящото издание на проекта <b>„Лъжеш ли?“</b>
        проверяваме истиността на изказванията на следните кандидати за кметове на местните избори на 29.10.2023:
      </p>

      <h3 class="pb-2 text-lg font-bold">София</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Антон Хекимян (ГЕРБ-СДС)</li>
        <li>Васил Терзиев (Продължаваме промяната-Демократична България и „Спаси София“)</li>
        <li>Ваня Григорова
          (БСП за България, „Левицата!“, Неутрална България, Алтернативата на гражданите и Атака)</li>
        <li>Деян Николов (Възраждане)</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Пловдив</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Костадин Димитров (ГЕРБ)</li>
        <li>Славчо Атанасов (Продължаваме промяната-Демократична България)</li>
        <li>Ивайло Старибратов (Съединени за Пловдив)</li>
        <li>Ангел Георгиев (Възраждане)</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Варна</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Иван Портних (ГЕРБ-СДС)</li>
        <li>Благомир Коцев (Продължаваме промяната-Демократична България)</li>
        <li>Коста Стоянов (Възраждане)</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Бургас</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Димитър Николов (ГЕРБ-СДС)</li>
        <li>Константин Бачийски (Средна европейска класа)</li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Обхватът на шестото издание на <b>„Лъжеш ли?“</b>
        са предизборните дебати и интервюта в национален ефир, които се проведоха в периода от
        <b>29.09.2023</b>
        до <b>27.10.2023</b>. Това включва всички предизборни дебати и интервюта по <b>БНТ</b>,
        <b>bTV</b>
        и <b>NOVA</b>.
      </p>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кой имаше най-много ефирно време?
      </summary>

      <p class="pb-4 text-lg">
        13-те кандидати от София, Пловдив, Варна и Бургас имаха следното ефирно време в рамките на предизборната кампания:
      </p>

      <h3 class="pb-2 text-lg font-bold">София</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Васил Терзиев &mdash; 139 минути</li>
        <li>Деян Николов &mdash; 122 минути</li>
        <li>Антон Хекимян &mdash; 102 минути</li>
        <li>Ваня Григорова &mdash; 102 минути</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Пловдив</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Славчо Атанасов &mdash; 50 минути</li>
        <li>Ивайло Старибратов &mdash; 44 минути</li>
        <li>Ангел Георгиев &mdash; 41 минути</li>
        <li>Костадин Димитров &mdash; 22 минути</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Варна</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Коста Стоянов &mdash; 45 минути</li>
        <li>Благомир Коцев &mdash; 43 минути</li>
        <li>Иван Портних &mdash; 18 минути</li>
      </ul>

      <h3 class="pb-2 text-lg font-bold">Бургас</h3>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>Константин Бачийски &mdash; 19 минути</li>
        <li>Димитър Николов &mdash; няма предизборни участия в национален ефир</li>
      </ul>
    </details>
    """
  end

  def election_details(%{year: 2023, month: "април"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на петото издание на проекта <b>„Лъжеш ли?“</b>
        проверихме истиността на изказванията на следните кандидати за народни представители на предсрочните парламентарни избори на 02.04.2023:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>Бойко Борисов</b> (ГЕРБ-СДС)</li>
        <li><b>Делян Добрев</b> (ГЕРБ-СДС)</li>
        <li><b>Тома Биков</b> (ГЕРБ-СДС)</li>
        <li><b>Даниел Митов</b> (ГЕРБ-СДС)</li>
        <li><b>Десислава Атанасова</b> (ГЕРБ-СДС)</li>
        <li><b>Кирил Петков</b> (Продължаваме промяната-Демократична България)</li>
        <li><b>Асен Василев</b> (Продължаваме промяната-Демократична България)</li>
        <li><b>Христо Иванов</b> (Продължаваме промяната-Демократична България)</li>
        <li><b>Атанас Атанасов</b> (Продължаваме промяната-Демократична България)</li>
        <li><b>Йордан Цонев</b> (ДПС)</li>
        <li><b>Мустафа Карадайъ</b> (ДПС)</li>
        <li><b>Рамадан Аталай</b> (ДПС)</li>
        <li><b>Ахмед Ахмедов</b> (ДПС)</li>
        <li><b>Костадин Костадинов</b> (Възраждане)</li>
        <li><b>Цончо Ганев</b> (Възраждане)</li>
        <li><b>Искра Михайлова</b> (Възраждане)</li>
        <li><b>Корнелия Нинова</b> (БСП за България)</li>
        <li><b>Георги Свиленски</b> (БСП за България)</li>
        <li><b>Кристиан Вигенин</b> (БСП за България)</li>
        <li><b>Борислав Гуцанов</b> (БСП за България)</li>
        <li><b>Стефан Янев</b> (Български възход)</li>
        <li><b>Виолета Комитова</b> (Български възход)</li>
        <li><b>Георги Самандов</b> (Български възход)</li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Обхватът на петото издание на <b>„Лъжеш ли?“</b>
        са предизборните дебати и интервюта в национален ефир, които се проведоха в периода от 03.03.2023 до 31.03.2023. Това включва всички предизборни дебати и интервюта по БНТ, bTV и NOVA.
      </p>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кой имаше най-много ефирно време?
      </summary>

      <p class="pb-4 text-lg">
        Шестте партии и коалиции на 23-мата кандидати в нашата извадка имаха следното ефирно време в рамките на предизборната кампания:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>Възраждане</b> &mdash; 218 минути</li>
        <li><b>ГЕРБ-СДС</b> &mdash; 182 минути</li>
        <li><b>Продължаваме промяната-Демократична България</b> &mdash; 177 минути</li>
        <li><b>БСП</b> за България &mdash; 153 минути</li>
        <li><b>Български</b> възход &mdash; 152 минути</li>
        <li><b>ДПС</b> &mdash; 13 минути</li>
      </ul>
    </details>
    """
  end

  def election_details(%{year: 2022, month: "октомври"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на четвъртото издание на проекта <b>„Лъжеш ли?“</b>
        проверихме истиността на изказванията на следните кандидати за народни представители на предсрочните парламентарни избори на 02.10.2022:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>Кирил Петков</b> („Продължаваме промяната“)</li>
        <li><b>Асен Василев</b> („Продължаваме промяната“)</li>
        <li><b>Радостин Василев</b> („Продължаваме промяната“)</li>
        <li><b>Десислава Атанасова</b> (ГЕРБ-СДС)</li>
        <li><b>Томислав Дончев</b> (ГЕРБ-СДС)</li>
        <li><b>Корнелия Нинова</b> (БСП за България)</li>
        <li><b>Георги Свиленски</b> (БСП за България)</li>
        <li><b>Йордан Цонев</b> (ДПС)</li>
        <li><b>Халил Летифов</b> (ДПС)</li>
        <li><b>Рамадан Аталай</b> (ДПС)</li>
        <li><b>Тошко Хаджитодоров</b> („Има такъв народ“)</li>
        <li><b>Станислав Балабанов</b> („Има такъв народ“)</li>
        <li><b>Гроздан Караджов</b> („Има такъв народ“)</li>
        <li><b>Христо Иванов</b> (Демократична България)</li>
        <li><b>Атанас Атанасов</b> (Демократична България)</li>
        <li><b>Костадин Костадинов</b> (Възраждане)</li>
        <li><b>Цончо Ганев</b> (Възраждане)</li>
        <li><b>Стефан Янев</b> (Български възход)</li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Четвъртото издание на <b>„Лъжеш ли?“</b>
        обхвана предизборните дебати и интервюта в национален ефир, които се проведоха в периода от 02.09.2022 до 30.09.2022. Това включва всички предизборни дебати и интервюта по БНТ, bTV и NOVA.
      </p>
    </details>
    """
  end

  def election_details(%{year: 2021, month: "ноември"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В третото издание на <b>„Лъжеш ли?“</b>
        проследихме истинността на изказванията на следните осем кандидати за президент на президентските избори на 14.11.2021:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>Румен Радев</b> (издигнат от инициативен комитет)</li>
        <li><b>Анастас Герджиков</b> (издигнат от инициативен комитет)</li>
        <li><b>Лозан Панов</b> (издигнат от инициативен комитет)</li>
        <li><b>Мустафа Карадайъ</b> (ДПС)</li>
        <li><b>Костадин Костадинов</b> (Възраждане)</li>
        <li><b>Валери Симеонов</b> (Патриотичен фронт)</li>
        <li><b>Веселин Марешки</b> (Воля)</li>
        <li><b>Милен Михов</b> (ВМРО)</li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Третото издание на <b>„Лъжеш ли?“</b>
        обхвана предизборните дебати и интервюта в национален ефир. Това включва изявите на кандидатите за президент по БНТ, bTV и NOVA.
      </p>
    </details>
    """
  end

  def election_details(%{year: 2021, month: "юли"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        В рамките на осем анкети попитахме последователите си във
        <a
          href="https://www.facebook.com/lazheshli"
          title="Последвайте ни във Facebook"
          class="underline"
        >
          Facebook
        </a>
        кои кандидати за народни представители на парламентарните избори на 11.07.2021 да следим. От всяка партия с резултат от над 3% на предишните парламентарни избори (04.04.2021) място намериха по петима кандидати, а от останалите по-малки партии добавихме общо петима участници. Проверявахме изказванията на следните кандидати, получили най-много гласове в анкетите:
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li>
          <b>ГЕРБ-СДС</b>: Бойко Борисов, Деница Сачева, Томислав Дончев, Даниел Митов и Десислава Атанасова
        </li>
        <li>
          <b>„Има такъв народ“</b>: Тошко Хаджитодоров, Филип Станев, Ива Митева, Андрей Чорбанов и Станислав Балабанов
        </li>
        <li>
          <b>БСП за България</b>: Корнелия Нинова, Крум Зарков, Иво Христов, Георги Кадиев и Кристиан Вигенин
        </li>
        <li>
          <b>ДПС</b>: Мустафа Карадайъ, Йордан Цонев, Петър Чобанов, Хасан Адемов и Рамадан Аталай
        </li>
        <li>
          <b>Демократична България</b>: Ивайло Мирчев, Атанас Атанасов, Христо Иванов, Найден Зеленогорски и Владислав Панев
        </li>
        <li>
          <b>„Изправи се! Мутри, вън!“</b>: Мая Манолова, Николай Хаджигенов, Татяна Дончева, Арман Бабикян и Настимир Ананиев
        </li>
        <li>
          <b>Българските патриоти</b>: Ангел Джамбазки, Александър Сиди, Искрен Веселинов, Кузман Илиев и Юлиан Ангелов
        </li>
        <li>
          <b>Малки партии и коалиции</b>: Васил Божков (Българско лято), Жан Виденов (Ляв съюз за чиста и свята република), Костадин Костадинов (Възраждане), Петър Москов (Национално обединение на десницата), Цветан Цветанов (Републиканци за България)
        </li>
      </ul>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Анализът ни обхвана всички предизборни дебати по БНТ, bTV и NOVA с участието на кандидати за народни представители и провели се от 11.06.2021 до 04.07.2021. В обхвата попаднаха също така предизборните интервюта в предаванията „Денят започва“ (БНТ), „Лице в лице“ (bTV) и „Здравей, България“ (NOVA).
      </p>

      <p class="pb-4 text-lg">
        Следните кандидати нямаха предизборни участия в национален ефир от 11.06.2021 до 04.07.2021.
      </p>

      <ul class="pb-4 pl-4 list-inside list-disc text-lg">
        <li><b>ГЕРБ-СДС</b>: Бойко Борисов, Деница Сачева и Десислава Атанасова</li>
        <li><b>„Има такъв народ“</b>: Филип Станев, Андрей Чорбанов и Станислав Балабанов</li>
        <li><b>БСП за България</b>: Георги Кадиев и Кристиан Вигенин</li>
        <li>
          <b>ДПС</b>: Мустафа Карадайъ, Йордан Цонев, Петър Чобанов, Хасан Адемов и Рамадан Аталай
        </li>
        <li><b>Демократична България</b>: Найден Зеленогорски и Владислав Панев</li>
        <li><b>„Изправи се! Мутри, вън!“</b>: Арман Бабикян и Настимир Ананиев</li>
        <li>
          <b>Малки партии и коалиции</b>: Васил Божков (Българско лято), Жан Виденов (Ляв съюз за чиста и свята република) и Цветан Цветанов (Републиканци за България)
        </li>
      </ul>
    </details>
    """
  end

  def election_details(%{year: 2021, month: "април"} = assigns) do
    ~H"""
    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои кандидати проверихме?
      </summary>

      <p class="pb-4 text-lg">
        Обектът на анализ по време на кампанията за парламентарните избори на 04.04.2021 бяха всички кандидати за народни представители.
      </p>
    </details>

    <details class="mb-6">
      <summary class="w-fit my-4 lg:pb-2 clear-both text-2xl lg:text-3xl leading-snug border-b-2 border-black cursor-pointer">
        Кои телевизии гледахме?
      </summary>

      <p class="pb-4 text-lg">
        Анализът ни обхвана всички предизборни дебати по БНТ, bTV и NOVA с участието на кандидати за народни представители и провели се от 05.03.2021 до 26.03.2021.
      </p>

      <p class="pt-4 text-lg">
        В проверявания период политическите формации „Има такъв народ“, „Глас народен“, „Консервативно Обединение на Десницата“ и „Българска прогресивна линия“ не участваха в нито един предизборен дебат в национален ефир.
      </p>
    </details>
    """
  end

  def election_details(assigns) do
    ~H""
  end
end
