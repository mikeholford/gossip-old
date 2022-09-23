import { whisper } from '../custom/helpers';
import { init_chat_display } from "../custom/message";

const initInfiniteScroll = () => {

  const infiniteScrollContainer = document.querySelector(".js-infinite-scroll-container");

  if (infiniteScrollContainer) {

    const resourceName = "message"

    const paginationObj = document.querySelector(
      ".js-infinite-scroll-pagination"
    );

    const loading =
      `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 40" stroke="currentColor" class="mx-auto has-text-primary" style="color: #cecece" height="40" width="40"><g fill="none" fill-rule="evenodd"><g transform="translate(1 1)" stroke-width="2"><circle stroke-opacity=".1" cx="18" cy="18" r="18"></circle><path d="M36 18c0-9.94-8.06-18-18-18"><animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="0.3s" repeatCount="indefinite"></animateTransform></path></g></g></svg>`;

    const error =
      `Error loading ${resourceName}s <br> Please refresh and try again`;

    const noMoreResources =
      `<div class='has-text-centered pb2'>----- End of ${resourceName}s -----</div>`;

    const noResourcesFound =
      `<div class='has-text-centered p4'>We could not find any ${resourceName}s</div>`;

    const insertHtml = (content) => {
      const documentHeight = document.body.scrollHeight;
      const scrollPosition = window.scrollY;
      content.forEach((entry) => {
        infiniteScrollContainer.insertAdjacentHTML("afterbegin", entry);
      });
      window.scrollTo(0, scrollPosition + document.body.scrollHeight - documentHeight);
      init_chat_display();
    };

    const loadMore = async () => {
      
      let url_string;

      if (infiniteScrollContainer.dataset.hasResources === "false") {
        infiniteScrollContainer.setAttribute("data-has-resources", "true");
        url_string = window.location.href;
      } else {
        const next_page = document.querySelector(
          ".js-infinite-scroll-pagination a[rel='next']"
        );
        if (next_page == null) {
          paginationObj.innerHTML = noMoreResources;
          return;
        }
        url_string = next_page.href;
        paginationObj.innerHTML = loading;
      }

      var url = new URL(url_string);
      url.searchParams.append('jsload', true);

      const result = await whisper(url.toString(), {}, "Error fetching messages", "GET" )
 
      paginationObj.innerHTML = result.pagination;
      paginationObj.querySelector(".pagy-nav").style.opacity = 0;

      insertHtml(result.html);

    };

    const processIntersectionEntries = (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          console.log("loading more");
          loadMore();
        }
      });
    };

    let options = {
      rootMargin: "100px",
    };

    const observer = new IntersectionObserver((entries) => processIntersectionEntries(entries), options);

    observer.observe(paginationObj);
  }
};

export { initInfiniteScroll };
