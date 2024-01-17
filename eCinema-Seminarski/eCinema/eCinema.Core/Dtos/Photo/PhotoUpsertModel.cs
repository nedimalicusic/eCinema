namespace eCinema.Core.Dtos.Photo
{
    public class PhotoUpsertModel
    {
        public string FileName { get; set; }
        public string Type { get; set; }
        public Stream Content { get; set; }
    }
}
