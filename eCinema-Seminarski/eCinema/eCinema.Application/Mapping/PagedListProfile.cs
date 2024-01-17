using eCinema.Core;

namespace eCinema.Application
{
    public class PagedListProfile : BaseProfile
    {
        public PagedListProfile()
        {
            CreateMap(typeof(PagedList<>), typeof(PagedList<>));
        }
    }
}
