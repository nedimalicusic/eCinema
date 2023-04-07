using eCinema.Core;

namespace eCinema.Application
{
    public class MovieProfile : BaseProfile
    {
        public MovieProfile()
        {
            CreateMap<MovieDto, Movie>().ReverseMap();

            CreateMap<MovieUpsertDto, Movie>();
        }
    }
}
